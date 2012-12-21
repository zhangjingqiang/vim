require "sinatra"
require "sinatra/static_assets"
require "open-uri"

configure :production do
    set :raise_errors, false
    set :show_exceptions, false
end

before do
    @google = 'http://www.google.com'
    @google_search = 'http://www.google.com/search?sitesearch=www.vim.org&as_q='
end

helpers do
    def avatar_url
        gravatar_id = Digest::MD5::hexdigest(ENV['EMAIL']).downcase
        "http://gravatar.com/avatar/#{gravatar_id}.png"
    end

    def vim_org(keyword = NULL)
        url = URI.escape("#{@google_search + keyword}")
        doc = Nokogiri::HTML(open(url), nil, "UTF-8")
        @content = Hash.new{|h, key| h[key] = []}
        doc.css("h3 a").each do |site|
            @content[:site_href] << site[:href]
            @content[:site_text] << site.text
        end
        doc.css("div[class='s'] span").each do |description|
            @content[:description] << description
        end
        @content
    end
end

get '/' do
    @scripts = vim_org('')
    erb :index
end

get '/search' do
    @scripts = vim_org(params[:s])
    erb :index
end

