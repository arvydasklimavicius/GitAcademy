//
//  LoginViewController.swift
//  GitAcademy
//
//  Created by Arvydas Klimavicius on 2021-06-22.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        githubAuth()
    }
    
    func githubAuth() {
        let uuid = UUID().uuidString
        webView.navigationDelegate = self
        let authURL = "https://github.com/login/oauth/authorize?client_id=" + GitHubAPI.clientId + "&scope=" + GitHubAPI.scope + "&redirect_uri=" + GitHubAPI.redirectUri + "&state=" + uuid
        let urlRequest = URLRequest(url: URL(string: authURL)!)
        webView.load(urlRequest)
    }
    
    
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.RequestForCallbackURL(request: navigationAction.request)
        decisionHandler(.allow)
    }
    
    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        print(requestURLString)
        if requestURLString.hasPrefix(GitHubAPI.redirectUri) {
            if requestURLString.contains("code=") {
                if let range = requestURLString.range(of: "=") {
                    let githubCode = requestURLString[range.upperBound...]
                    if let range = githubCode.range(of: "&state=") {
                        let githubCodeFinal = githubCode[..<range.lowerBound]
                        githubRequestForAccessToken(authCode: String(githubCodeFinal))

                        // Close GitHub Auth ViewController after getting Authorization Code
//                        self.dismiss(animated: true, completion: nil)
                        DispatchQueue.main.async {
                            let vc = self.storyboard?.instantiateViewController(identifier: "Home") as! HomeViewController
                            self.present(vc, animated: true, completion: nil)
                        }
                        
                    }
                }
            }
        }
    }

    func githubRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"

        // Set the POST parameters.
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&client_id=" + GitHubAPI.clientId + "&client_secret=" + GitHubAPI.clientSecret
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: GitHubAPI.accessTokenURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, _) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                let accessToken = results?["access_token"] as! String
                // Get user's id, display name, email, profile pic url
//                self.fetchGitHubUserProfile(accessToken: accessToken)
                print("🟢🟢🟢\(accessToken)")
            }
        }
        task.resume()
    }
}
