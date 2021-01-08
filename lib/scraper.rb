require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  index_url = open('https://learn-co-curriculum.github.io/student-scraper-test-page/')
  # site = Nokogiri::HTML(html)

  def self.scrape_index_page(index_url)
    html = open(index_url)
    site = Nokogiri::HTML(html)
    student_index = []

    full_roster = site.css("div.student-card")
    
    full_roster.each do |student|
      student_index << { 
        :name => student.css("div.card-text-container h4.student-name").text,
        :location => student.css("div.card-text-container p.student-location").text,
        :profile_url => student.css("a").map {|link| link["href"]}.join
      }
    end
    student_index
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    site = Nokogiri::HTML(html)
    student_info = {}

    social_link = site.css("div.social-icon-container a").map {|link| link["href"]}

    social_link.each do |link|
      student_info[:twitter] = link if link.include?("twitter")
      student_info[:linkedin] = link if link.include?("linkedin")
      student_info[:github] = link if link.include?("github")
      student_info[:blog] = link if social_link[3] != nil
    end

    student_info[:profile_quote] = site.css("div.vitals-text-container div.profile-quote").text
    student_info[:bio] = site.css("div.description-holder p").text
    student_info
  end

end

Scraper.scrape_profile_page('https://learn-co-curriculum.github.io/student-scraper-test-page/students/ryan-johnson.html')
