//
//  ViewController.swift
//  sellerprofileandmenu
//
//  Created by Chirag Jain on 6/16/15.
//  Copyright (c) 2015 Mango Revolutions. All rights reserved.
//

import UIKit
import JavaScriptCore

protocol CheckoutResultsDelegate
{
    func razorpayCallBack(var status : Int,var extra : String)
}

class RazorpayCheckout: UIViewController,UIWebViewDelegate {
    
    
    var cartdelegate:CheckoutResultsDelegate?
    var  webViewJSBridge : WebViewJavascriptBridge?
    var razorpayOptions : NSArray?
    var delim = "!#%@$^"
    var popupWebView : UIWebView?
    var activeWebView : UIWebView?
    @IBOutlet weak var razorpayWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        razorpayWebView.delegate = self
        if(Reachability.isConnectedToNetwork())
        {
            
            //DO NOT CHANGE THE ORDER OF ARRAY
            //key,amount,vendor_name,currency,prefill.name,prefill.phone,prefill.email
            var payString = razorpayOptions?.componentsJoinedByString(delim)
            webViewJSBridge = WebViewJavascriptBridge(forWebView: razorpayWebView, webViewDelegate: self) {
                (data, responseCallback) -> Void in
                println(data)
                var status : Int  = (data as! String).componentsSeparatedByString(self.delim)[0].toInt()!
                var extraString : String = (data as! String).componentsSeparatedByString(self.delim)[1]
                self.cartdelegate?.razorpayCallBack(status, extra: extraString)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            
           razorpayWebView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("razorpay", ofType: "html")!, isDirectory: false)!))
            razorpayWebView.scrollView.bounces=false
            activeWebView = razorpayWebView
            
            //init payment
            webViewJSBridge?.send(payString)

        }
        else
        {
            var alert = UIAlertController(title: "Oops", message: "No Internet Connection", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                switch action.style{
                case .Default:
                    self.cartdelegate?.razorpayCallBack(0, extra: "No Internet Connection")
                    self.dismissViewControllerAnimated(true, completion: nil)
                default:
                    println("Not Happening")
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        
    }
}
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        println(request.URL?.absoluteString)
        if((request.URL?.standardizedURL?.absoluteString)!.rangeOfString("processing") != nil)
        {
            popupWebView = UIWebView(frame: razorpayWebView.frame)
            popupWebView?.bounds = razorpayWebView.bounds
            self.view.addSubview(popupWebView!)
            var parentContext : JSContext = razorpayWebView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
            var childContext : JSContext = popupWebView?.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
            childContext.objectForKeyedSubscript("window").setObject(parentContext.objectForKeyedSubscript("window"), forKeyedSubscript: "opener")
            popupWebView?.loadRequest(request)
            activeWebView =  popupWebView
            return false
        }
        

        //childContext[@"window"][@"opener"] = parentContext["window"]
        
        return true
    }

    
    
    func goback() -> Void
    {
        popupWebView?.removeFromSuperview()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}



//view begins
//make razorpay options dictionary
//send that to js using swifttojscalls
//JS inits razorpay
//ondismiss and onsuccess do jstoswiftcalls

