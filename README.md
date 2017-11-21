# Mailgun-In-Swift

[![CocoaPods](https://img.shields.io/badge/pod-v1.0.0-blue.svg)](https://img.shields.io/badge/pod-v1.0.0-blue.svg)    [![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/KevinAo22/Mailgun-In-Swift/blob/master/LICENSE)    [![Swift 4](https://img.shields.io/badge/LANGUAGE-Swift%204-orange.svg)](https://swift.org)

Mailgun-In-Swift provides simple alternative APIs when you need to send an email with your iOS app using Mailgun.

:question: Why?
----
For developing iOS App, we need to send a email in background without any action sometimes. Or there is the need to send a simple email instead of using `MailComposeViewController` or `SMTP` libray. In these cases, sending emails using Mailgun is a better option. This project help you simplify the original Mailgun APIs and provide you a simple alternative in Swift.

:email: Mailgun
----
[Mailgun](https://mailgun.com) provides a simple reliable API for transactional emails. You will need to have an `ApiKey` and an account to use the client.

:octocat: Installation
----
Get `Mailgun-In-Swift` on CocoaPods, just add `pod 'Mailgun-In-Swift'` to your Podfile.

:mortar_board: Usage
-----
Usage is very simple

```Swift

import Mailgun-In-Swift

let mailgun = MailgunAPI(apiKey: "YouAPIKey", clientDomain: "yourDomain.com")

mailgun.sendEmail(to: "to@test.com", from: "Test User <test@test.com>", subject: "This is a test", bodyHTML: "<b>test<b>") { mailgunResult in

  if mailgunResult.success{
    print("Email was sent")
  }

}

```

:v: License
-------
MIT

:alien: Author
------
Ao Zhang - https://kevinao.com