module URI
  # escape whitespace in  a string
  module_function
  def encode(str)
    if str
      CFURLCreateStringByAddingPercentEscapes nil, str.to_s, "[]", ";=&,@", KCFStringEncodingUTF8
    end
  end

  module_function
  def validate_url(url)
    # Takes a ruby string and validates it as a url
    if NSURLConnection.canHandleRequest(NSURLRequest.requestWithURL(url.nsurl))
      url
    else
      false
    end

  end
end
