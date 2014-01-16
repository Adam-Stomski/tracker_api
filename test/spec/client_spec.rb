require_relative '../minitest_helper'

describe PivotalTracker do
  it 'has a version' do
    ::PivotalTracker::VERSION.wont_be_nil
  end
end

describe PivotalTracker::Client do
  it 'can be configured' do
    client = PivotalTracker::Client.new(url:         'http://test.com',
                                        api_version: '/foo-bar/1',
                                        token:       '12345')

    client.url.must_equal 'http://test.com'
    client.api_version.must_equal '/foo-bar/1'
    client.token.must_equal '12345'
  end

  #it 'can get epics for a project' do
  #  client = PivotalTracker::Client.new
  #
  #  projects = client.projects.all
  #  projects.wont_be_empty
  #
  #  epics = projects.first.epics
  #  epics.wont_be_empty
  #end


end
