# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(title: movie['title'], rating: movie['rating'], release_date: movie['release_date'])
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |movie1, movie2|
  texts = page.all("table#movies td").collect(&:text)
  texts.length.should be > 0, "#{texts}"
  texts.index(movie1).should be < texts.index(movie2), "#{texts}"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /^I check the following ratings: (.*)$/ do |rating_list|
  rating_list.split(",").each do |rating|
    page.check "ratings_#{rating}"
  end
end

When /I uncheck the following ratings: (.*)/ do |rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |rating|
    page.uncheck "ratings_#{rating}"
  end
end

Given /^I click the "(.*?)" button$/ do |button|
  page.click_button(button)
end

Then /^I should see all the PG and R movies$/ do
  page.should have_selector('tr', text: "")
end

Then /^I should not see any of the G, PG\-(\d+), and NC\-(\d+) movies$/ do |arg1, arg2|
  page.should_not have_content "Aladdin"
  page.should_not have_content "Chocolat"
end

Given /^I uncheck all the ratings$/ do
  page.uncheck "ratings_G"
  page.uncheck "ratings_PG"
  page.uncheck "ratings_R"
  page.uncheck "ratings_PG-13"
  page.uncheck "ratings_NC-17"
end

Given /^I check all the ratings$/ do
  page.check "ratings_G"
  page.check "ratings_PG"
  page.check "ratings_R"
  page.check "ratings_PG-13"
  page.check "ratings_NC-17"
end

Then /^I should see all the movies$/ do
  page.all('tr').length.should equal(11)
end
