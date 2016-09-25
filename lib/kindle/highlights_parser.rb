require "highline/import"

module Kindle

  class HighlightsParser

    include Nokogiri

    def initialize(options = {:login => nil, :password => nil})
      options.each_pair { |k,v| instance_variable_set("@#{k}", v) }
      @fetch_count = 1
    end

    def get_highlights
      state = {
                current_offset:   25,
                current_upcoming: []
              }

      page = login
      fetch_highlights(page, state)
    end

    private

    def agent
      return @agent if @agent
      @agent = Mechanize.new
      @agent.redirect_ok = true
      if ENV['USER_AGENT']
        @agent.user_agent = ENV['USER_AGENT']
      else
        @agent.user_agent_alias = ENV['USER_AGENT_ALIAS'] || "Mac Safari"
      end
      @agent
    end

    def get_login_page
      page = agent.get(AmazonInfo.kindle_url)
      page.link_with(:text => 'Your Highlights').click
    end

    def login
      login_page = get_login_page
      login_form = login_page.forms.first
      login_form.email    = @login
      login_form.password = @password

      page = login_form.submit
      raise Kindle::LoginFailed, "Failed in login.\n#{page.body.toutf8}" if got_wrong_password_error?(page)
      page
    end

    def secure_question_page?(page)
      page.forms.first.name == "ap_dcq_form"
    end

    def got_wrong_password_error?(page)
      page.body.toutf8.include?('パスワードが正しくありません')
    end

    def answer_sequre_question(page)
      find_question_answers
      secure_form = page.forms.first
      if @question_type == '1'
        secure_form.dcq_question_subjective_1 = @phone_number
      elsif  @question_type == '2'
        secure_form.dcq_question_subjective_2 = @zip_code
      end
      page = secure_form.submit
      raise Kindle::SecurityQuestionFailed, "Failed in answering security question.\n#{page.body.toutf8}" if secure_question_page?(page)
      page
    end

    def find_question_answers
      if ENV['PHONE_NUMBER'].present?
        @question_type = '1'
        @phone_number = ENV['PHONE_NUMBER']
      elsif ENV['ZIP_CODE'].present?
        @question_type = '1'
        @zip_code = ENV['ZIP_CODE']
      else
        @question_type ||= loop do
          input = ask "Which do you answer 1. Phone number OR 2. Zip Code: "
          break input if ['1', '2'].include?(input)
          puts "Wrong input [#{input}]. Input 1 OR 2."
        end
        if @question_type == '1'
          @phone_number = ask("Input your phone number: ")
        elsif @question_type == '2'
          @zip_code = ask("Input your zip code: ")
        end
      end
      raise("Failed on secure question #{page.body.toutf8}") unless @question_type && (@phone_number || @zip_code)
    end

    def fetch_highlights(page, state)
      page = get_the_first_highlight_page_from(page, state)
      highlights = extract_highlights_from(page, state)

      begin
        page = get_the_next_page(state, highlights.flatten)
        new_highlights = extract_highlights_from(page, state)
        highlights << new_highlights
      end until new_highlights.length == 0 || reach_fetch_count_limit?

      highlights.flatten
    end

    def get_the_first_highlight_page_from(page, state)
      page = answer_sequre_question(page) if secure_question_page?(page)
      page = page.link_with(:text => 'Your Highlights').click
      initialize_state_with_page state, page
      page
    end

    def extract_highlights_from(page, state)
      return [] if (page/".yourHighlight").length == 0
      (page/".yourHighlight").map { |hl| parse_highlight(hl, state) }
    end

    def initialize_state_with_page(state, page)
      return if (page/".yourHighlight").length == 0
      state[:current_upcoming] = (page/".upcoming").first.text.split(',') rescue []
      state[:title] = (page/".yourHighlightsHeader .title").text.to_s.strip
      state[:author] = (page/".yourHighlightsHeader .author").text.to_s.strip.gsub(/\Aby /, '')
      state[:current_offset] = ((page/".yourHighlightsHeader").collect{|h| h.attributes['id'].value }).first.split('_').last
      state[:last_annotated_on] = Date.parse (page/".lastHighlighted").text[/Last annotated on (.*)/, 1]
    end

    def get_the_next_page(state, previously_extracted_highlights = [])
      asins           = previously_extracted_highlights.map(&:asin).uniq
      asins_string    = asins.collect { |asin| "used_asins[]=#{asin}" } * '&'
      upcoming_string = state[:current_upcoming].map { |l| "upcoming_asins[]=#{l}" } * '&'
      url = "#{AmazonInfo.kindle_https_url}/your_highlights/next_book?#{asins_string}&current_offset=#{state[:current_offset]}&#{upcoming_string}"
      puts "Getting: #{url}"
      ajax_headers = { 'X-Requested-With' => 'XMLHttpRequest', 'Host' => "kindle.#{AmazonInfo.domain}" }
      page = agent.get(url,[],"#{AmazonInfo.kindle_https_url}/your_highlight", ajax_headers)
      increment_fetch_count

      initialize_state_with_page state, page

      puts "Fetched: #{state[:title]}"
      page
    end

    def parse_highlight(hl, state)
      highlight_id = (hl/"#annotation_id").last["value"] rescue 'note_only'
      if highlight_id == 'note_only'
        highlight    = (hl/".context").text
      else
        highlight    = (hl/".highlight").text
      end
      asin         = (hl/".asin").text
      location     = (hl/".linkOut").first['href'][/&location=(\d+)\z/, 1] # kindle://book?action=open&asin=XXX&location=YYY
      note_id      = (hl/".editNote .annotation_id").text
      note         = (hl/".editNote .noteContent").text
      Highlight.new(highlight_id, highlight, asin, location, state[:title], state[:author], state[:last_annotated_on], note_id, note)
    end

    def increment_fetch_count
      @fetch_count += 1
    end

    def reach_fetch_count_limit?
      return false unless ENV['FETCH_COUNT_LIMIT']
      @fetch_count >= ENV['FETCH_COUNT_LIMIT'].to_i
    end

  end

end

