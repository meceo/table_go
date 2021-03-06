# encoding: UTF-8
require 'spec_helper'

ActionView::Base.send :include, TableGo::Helpers

describe TableGo::Helpers do
  let(:articles) do
    [ Article.new(:title => 'iPutz',
        :date_of_order => Date.new(2012), :ident => 1, :vat => 19, :price => 5, :xmas_bonus => true,
        :my_type => 'super_type'),
      Article.new(:title => 'Nutzbook',
        :date_of_order => Date.new(2012), :ident => 2, :vat => 19, :price => 5, :xmas_bonus => false,
        :my_type => 'hardware_type') ]
  end

  let(:template) { action_view_instance }


  describe 'integration in haml template' do
    let(:subject) do
      Haml::Engine.new(read_file_from_fixtures_path('simple_table.html.haml')).render(template, :articles => articles)
    end

    it "it should render in haml" do
      subject.cleanup_html.should eql %Q(
        <p>Suppe</p>
        <table>
          <thead>
            <tr>
              <th>Ident</th>
              <th>Custom single cell</th>
              <th>Custom multiline cell</th>
              <th>Custom single cell with backwards compatibility</th>
              <th>field with_html_markup</th>
            </tr></thead>
          <tbody>
            <tr>
              <td>1</td>
              <td>Ident: 1 - Title: iPutz</td>
              <td>Ident: 1 - Title: iPutz</td>
              <td>Ident: 1</td>
              <td><a href="http://nowhere.com">click me</a><br /><a href="http://otherwhere.com">and here</a></td>
            </tr>
            <tr>
              <td>2</td>
              <td>Ident: 2 - Title: Nutzbook</td>
              <td>Ident: 2 - Title: Nutzbook</td>
              <td>Ident: 2</td>
              <td><a href="http://nowhere.com">click me</a><br /><a href="http://otherwhere.com">and here</a></td>
            </tr>
          </tbody>
        </table>
        <p>Pampe</p>
      ).cleanup_html
    end
  end

  describe 'integration in haml template for a table_rows_for' do
    let(:subject) do
      Haml::Engine.new(read_file_from_fixtures_path('table_rows_for.html.haml')).render(template, :articles => articles.first)
    end

    it "it should render in haml" do
      subject.cleanup_html.should eql %Q(
        <tr>
          <td>1</td>
          <td>Ident: 1 - Title: iPutz</td>
          <td>Ident: 1 - Title: iPutz</td>
          <td>Ident: 1</td>
          <td><a href="http://nowhere.com">click me</a><br /><a href="http://otherwhere.com">and here</a></td>
        </tr>
      ).cleanup_html
    end
  end

  describe 'integration in haml template for a table_go_for with options render_rows_only "true"' do
    let(:subject) do
      Haml::Engine.new(read_file_from_fixtures_path('table_go_for_with_only_rows.html.haml')).
        render(template, :articles => articles.first)
    end

    it "it should render in haml" do
      subject.cleanup_html.should eql %Q(
        <tr>
          <td>1</td>
          <td>Ident: 1 - Title: iPutz</td>
          <td>Ident: 1 - Title: iPutz</td>
          <td>Ident: 1</td>
          <td><a href="http://nowhere.com">click me</a><br /><a href="http://otherwhere.com">and here</a></td>
        </tr>
      ).cleanup_html
    end
  end

  describe 'integration in haml template for a table_go_for with options without_header "true"' do
    let(:subject) do
      Haml::Engine.new(read_file_from_fixtures_path('table_go_for_without_header.html.haml')).
        render(template, :articles => articles.first)
    end

    it "it should render in haml" do
      subject.cleanup_html.should eql %Q(
        <table>
          <tbody>
            <tr>
              <td>1</td>
              <td>Ident: 1 - Title: iPutz</td>
              <td>Ident: 1 - Title: iPutz</td>
              <td>Ident: 1</td>
              <td><a href="http://nowhere.com">click me</a><br /><a href="http://otherwhere.com">and here</a></td>
            </tr>
          </tbody>
        </table>
      ).cleanup_html
    end
  end

  # context 'speedtest' do

  #   let(:more_articles) { 1000.times.map { articles }.flatten }


  #   it 'should run fast' do
  #     puts Benchmark.measure {
  #       2.times do
  #         Haml::Engine.new(read_file_from_fixtures_path('simple_table.html.haml')).render(template, :articles => more_articles)
  #       end
  #     }
  #   end

  # end

end

