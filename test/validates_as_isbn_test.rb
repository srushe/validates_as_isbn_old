require 'test/unit'

begin
  require File.dirname(__FILE__) + '/../../../../config/boot'
  require 'active_record'
  require 'validates_as_isbn'
rescue LoadError
  require 'rubygems'
  gem 'activerecord'
  require 'active_record'
  require File.dirname(__FILE__) + '/../lib/validates_as_isbn'
end

class TestRecord < ActiveRecord::Base
  def self.columns; []; end
  attr_accessor :isbn
  validates_as_isbn :isbn
end

class ValidatesAsIsbnTest < Test::Unit::TestCase
  # Check that valid 10-digit isbns are validated as such.
  def test_should_validate_10_digit_isbn
    isbns = IO.readlines(File.dirname(__FILE__) + '/../data/valid_isbn_10.txt')

    isbns.each do |isbn|
      isbn.chomp!
      assert TestRecord.new(:isbn => isbn).valid?, "#{isbn} should be valid."
      assert TestRecord.new(:isbn => isbn.downcase).valid?, "#{isbn.downcase} should be valid."
      assert TestRecord.new(:isbn => isbn.gsub('[^0-9X]', '')).valid?, "#{isbn.gsub('[^0-9X]', '')} should be valid."
      assert TestRecord.new(:isbn => isbn.downcase.gsub('[^0-9X]', '')).valid?, "#{isbn.downcase.gsub('[^0-9X]', '')} should be valid."
    end
  end

  # Check that valid 13-digit isbns are validated as such.
  def test_should_validate_13_digit_isbn
    isbns = IO.readlines(File.dirname(__FILE__) + '/../data/valid_isbn_13.txt')

    isbns.each do |isbn|
      isbn.chomp!
      assert TestRecord.new(:isbn => isbn).valid?, "#{isbn} should be valid."
      assert TestRecord.new(:isbn => isbn.downcase).valid?, "#{isbn.downcase} should be valid."
      assert TestRecord.new(:isbn => isbn.gsub('[^0-9X]', '')).valid?, "#{isbn.gsub('[^0-9X]', '')} should be valid."
      assert TestRecord.new(:isbn => isbn.downcase.gsub('[^0-9X]', '')).valid?, "#{isbn.downcase.gsub('[^0-9X]', '')} should be valid."
    end
  end

  # Check that invalid isbns are validated as such.
  def test_should_not_validate
    isbns = IO.readlines(File.dirname(__FILE__) + '/../data/invalid.txt')

    isbns.each do |isbn|
      isbn.chomp!
      assert !TestRecord.new(:isbn => isbn).valid?, "#{isbn} should be invalid."
      assert !TestRecord.new(:isbn => isbn.downcase).valid?, "#{isbn.downcase} should not be invalid."
      assert !TestRecord.new(:isbn => isbn.gsub('[^0-9X]', '')).valid?, "#{isbn.gsub('[^0-9X]', '')} should be invalid."
      assert !TestRecord.new(:isbn => isbn.downcase.gsub('[^0-9X]', '')).valid?, "#{isbn.downcase.gsub('[^0-9X]', '')} should be invalid."
    end
  end
end
