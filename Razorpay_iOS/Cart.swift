//
//  Cart.swift
//
//  Created by Chirag Jain on 6/16/15.
//

import Foundation
class Cart: UIViewController,CheckoutResultsDelegate
{
    var total_price: Double = 0
    var name : NSString = ""
    var email : NSString = ""
    var phone : NSString = ""
    var key : NSString = "rzp_test_1DP5mmOlF5G5ag"
    var vendor_name : NSString = "FoodBytes"
    var currency : NSString = "INR"
    
    
    func razorpayCallBack(status : Int, extra : String)
    {
        if(status == 0)
        {
            println("No Connection")
            println(extra)
        }
        else if(status == 1)
        {
            println("Canceled")
            println(extra)
        }
        else if(status == 2)
        {
            println("Paid")
            println(extra)
        }
    }
    
    @IBOutlet weak var paybutton: UIButton!
    
    @IBAction func beginCheckout(sender: UIButton) {
    
        //DO NOT CHANGE THE ORDER OF ARRAY
        //key,amount,vendor_name,currency,prefill.name,prefill.phone,prefill.email
        var total_price_string = NSString(format: "%d", (Int)(total_price * 100))
        var Options : [NSString] = [key,total_price_string,vendor_name,currency,name,phone,email]
        var razorpayCheckoutController : RazorpayCheckout = RazorpayCheckout(nibName: "RazorpayCheckout", bundle: nil)
        razorpayCheckoutController.edgesForExtendedLayout = UIRectEdge.None
        razorpayCheckoutController.cartdelegate = self
        razorpayCheckoutController.razorpayOptions = Options
        self.presentViewController(razorpayCheckoutController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //HARCODE
        total_price = 500.00
        name = "Chirag Jain"
        email = "chirag@eye2i.co"
        phone = "8097678009"
        //HARDCODE
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//    override func viewDidLayoutSubviews() {
//        
//        if((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 7.0)
//        {
//            var viewBounds : CGRect = self.view.bounds
//            var topBarOffset : CGFloat = self.topLayoutGuide.length
//            viewBounds.origin.y = topBarOffset * -1;
//            viewBounds.size.height = viewBounds.size.height + (topBarOffset * -1);
//            self.view.bounds = viewBounds;
//        }
//    }
}