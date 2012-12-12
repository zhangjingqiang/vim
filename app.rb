require "sinatra"
require "sinatra/static_assets"
require "open-uri"

configure :production do
  set :raise_errors, false
  set :show_exceptions, false
end

before do
  @about_me = 'http://about.me/zhangjingqiang'
  @twitter = 'http://twitter.com/zhangjingqiang'
  @facebook = 'https://www.facebook.com/zhangjingqiang'
  @google_plus = 'https://plus.google.com/111238723646169905787'
  @github = 'https://github.com/zhangjingqiang'
  @email = 'zhangjingqiang@gmail.com'
  @google = 'http://www.google.com'
  @google_search = 'http://www.google.com/search?sitesearch=www.vim.org&as_q='
end

helpers do
	def avatar_url
  	gravatar_id = Digest::MD5::hexdigest(@email).downcase
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

