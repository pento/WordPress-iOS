import Foundation

class WPRichTextEmbed : UIView, UIWebViewDelegate, WPRichTextMediaAttachment
{
    typealias successBlock = ((WPRichTextEmbed)->())


    // MARK: Properties

    var fixedHeight : CGFloat = 0.0
    var attachmentSize = CGSizeZero
    var documentSize = CGSizeZero
    var success : successBlock?
    var linkURL : NSURL?
    var contentURL : NSURL?

    private var webView : UIWebView


    // MARK: LifeCycle

    override init(frame: CGRect) {
        webView = UIWebView(frame: CGRectMake(0.0, 0.0, 100.0, 100.0)) // arbitrary frame

        super.init(frame: frame);

        clipsToBounds = true
        configureWebView()
    }

    required init(coder aDecoder: NSCoder) {
        if let decodedWebView = aDecoder.decodeObjectForKey("webView") as? UIWebView {
            webView = decodedWebView
        } else {
            webView = UIWebView(frame: CGRectMake(0.0, 0.0, 100.0, 100.0))
        }

        super.init(coder: aDecoder)

        configureWebView()
    }

    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(webView, forKey: "webView")

        super.encodeWithCoder(aCoder)
    }


    // MARK: Configuration

    func configureWebView() {
        webView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        webView.scrollView.scrollEnabled = false
        webView.scalesPageToFit = true
        webView.delegate = self
    }


    // MARK: Public Methods

    func contentSize() -> CGSize {
        // embeds, unlike images, typically have no intrinsic content size that we can use to fall back on
        if (fixedHeight > 0) {
            return CGSizeMake(CGFloat(CGFLOAT_WIDTH_UNKNOWN), fixedHeight)
        }
        return CGSizeZero
    }

    func contentRatio() -> CGFloat {
        if (fixedHeight > 0) {
            return 0.0
        }

        if !CGSizeEqualToSize(attachmentSize, CGSizeZero) {
            return attachmentSize.width / attachmentSize.height
        }

        if (!CGSizeEqualToSize(documentSize, CGSizeZero)) {
            return documentSize.width / documentSize.height
        }

        return 0.0
    }

    func loadContentURL(url: NSURL) {
        contentURL = url
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }

    func loadHTMLString(html: NSString) {
        var htmlString = NSString(format: "<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0\" /></head><body>%@</body></html>", html)
        webView.loadHTMLString(htmlString, baseURL: nil)
    }

    // MARK: WebView delegate methods

    func webViewDidFinishLoad(webView: UIWebView) {
        // Add the webView as a subview if it hasn't been already.
        if webView.superview == nil {
            // The scrollWidth/scrollHeight is not a reliable way of getting the
            // minimum width/height of the web content without scrolling. Chances
            // of a good width/height go up while the starting frame is small so
            // we'll only update once.
            var scrollWidth = webView.stringByEvaluatingJavaScriptFromString("document.body.scrollWidth")?.toInt()
            var scrollHeight = webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight")?.toInt()
            var width = 0
            var height = 0
            if scrollWidth != nil {
                width = scrollWidth!
            }
            if scrollHeight != nil {
                height = scrollHeight!
            }

            documentSize = CGSizeMake(CGFloat(width), CGFloat(height))

            webView.frame = bounds
            addSubview(webView)
        }

        // Perform the callback, but only once.
        if let callback = success {
            callback(self)
        }
        success = nil
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        // TODO : Log error
        // DDLogError()
    }

}
