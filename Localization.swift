//
//  Localization.swift
//  Xpert
//
//  Created by Darius on 2019-11-13.
//  Copyright © 2019. All rights reserved.
//

import Foundation


final class Localization: NSObject {

    static let shared = Localization()
    
    var too_long_max_16 = "Max 16 characters"
    var too_short_min_2 = "Min 2 characters"
    var finish_signup = "Lets finish your Sign up"
    var finish_upgrade = "Lets finish your Upgrade"
    var subject = "Subject"
    var activation_link_is_sent = "email resent"
    var new_device = "We recognize this device as new. Will you add this device to your list?"
    var logout_x_sec = "You will be logout after {{count}} seconds"
    var everything_ok = "Everything looks OK!"
    var terms_6_1_b = "clause 7.2;"
    var page_x_of_count = "Page {{current}} of {{count}}"
    var browser_version = "Browser version"
    var your_subscription = "Your Subscription"
    var os_support_error = "Your operating system is not supported"
    var subject_max_char = "subject must be at most 512 characters"
    var message_max_char = "message must be at most 512 characters"
    var outdated = "Outdated"
    var need_to_reassess = "Need To Reassess"
    var message_is_sent = "Your message has been sent"
    var scanning_browser = "Scanning browser..."
    var scanning_os = "Scanning operating system..."
    var found = "Found"
    var device_add_success = "Device successfully added"
    var invalid_credentials = "Invalid login credentials"
    var unknown = "Unknown"
    var select = "Select"
    var coming_soon = "Coming soon"
    var raw_data_exposed = "Raw Data Exposed"
    var your_plan = "Your plan"
    var family_member = "Family member"
    var non_family_member = "Personal"
    var plan_status_processing = "Processing..."
    var one_minute_left_to_auto_logout = "Only one minute left to autologout"
    var browser_product = "Browser name"
    var browser_vendor = "Browser provider"
    var build_version_number = "Build version number"
    var operation_system = "Operation System"
    var i_dont_know = "I don't know"
    var confirm = "confirm"
    var provided_data = "Provided Data"
    var or = "or"
    var this_link = "this link"
    var good_luck = "Good luck"
    var please_try = "Please try"
    var page_might_have_been_removed = "The page you are looking for might have been removed, had its name changed or is temporarily unavailable"
    var error = "Error"
    var tp_12_2 = "uses cookies. For more information on which cookies we use and how we use them, please see our Cookies Policy."
    var tp_12_1 = "Our website"
    var tp_12_strong = "Cookies."
    var tp_11 = "If you have a concern about the way we handle your personal data you have a right to raise this concern with the UK information regulator, the ICO:"
    var tp_11_strong = "UK information regulator."
    var tp_10 = "We welcome your feedback and questions. If you would like to contact us in relation to this Policy please send an email to "
    var tp_10_strong = "How to contact us."
    var tp_9 = "We draw your attention to your following rights under data protection law: (i) the right to request a copy of the information that we hold about you and supplementary details about that information; (ii) the right to have inaccurate personal data that we process about you rectified, (iii) the right (in certain circumstances) to have personal data that we process about you blocked, erased or destroyed; (iv) the right to object to the processing of your personal information in the ways described in clauses 4.2 (Security and fraud prevention), and 4.3 and 8 (Marketing); and (v) on or after 25 May 2018, the right to request a copy your personal data that you have provided to us, in a machine-readable format, in order for you to transmit those data to another organisation. Further information about your information rights is available on the ICO\u{2019}s website:"
    var tp_9_strong = "Your information rights."
    var tp_8 = "We may store your contact details, and carry out marketing profiling activities, for direct marketing purposes. Where you have given your consent, or where we are otherwise permitted to do so, we may contact you about our products or services that may be of interest to you. If you prefer not to receive any direct marketing communications from us, you can opt out at any time by sending an email to"
    var tp_8_strong = "Marketing."
    var tp_7 = "We carefully consider the personal data that we store, and we will not keep your information in a form which identifies you for longer than is necessary for the purposes set out in this Policy. You also have the rights referred to in clause 9 in relation to your personal information that we process."
    var tp_7_strong = "Data retention period."
    var tp_6 = "While we are based in London, we may transfer your personal information to a location (for example to a secure server) outside the European Economic Area, where we consider it necessary or desirable for the purposes set out in this Policy. In such cases, to safeguard your privacy rights, transfers will be made to recipients to which a European Commission adequacy decision applies (this is a decision from the Commission confirming that adequate safeguards are in place for the protection of personal data), or will be carried out under the standard contractual clauses for controller-to-processor transfers approved by the Commission on 5 February 2010 (Commission Decision C(2010)593), a copy of which is available to view on the Commission \u{2019}s website "
    var tp_6_strong = "Information transfers."
    var tp_5_3 = "law enforcement agencies in connection with any investigation to help prevent unlawful activity."
    var tp_5_2 = "our employees, consultants, agents and service providers;"
    var tp_5_1 = "other companies within our group;"
    var tp_5 = "We may provide your personal information to the following recipients for the purposes set out in this Policy:"
    var tp_5_strong = "Who we may provide your personal information to."
    var tp_4_5 = "We may process your personal information in order to comply with applicable laws (for example if we are required to cooperate with a police investigation pursuant to a court order)."
    var tp_4_5_strong = "Compliance with laws."
    var tp_4_4 = "We may anonymise your personal information and aggregate it with other information for the purposes of statistical or research purposes. We may provide such information to third parties after it has been anonymised so that it cannot be used to identify you."
    var tp_4_4_strong = "Statistical or research purposes."
    var tp_4_3 = "We may process your personal information in order to let you know about our products or services that we consider may be of interest to you. We carry out this processing on the legal basis that we have a legitimate interest in marketing our services and only to the extent that we are permitted to do so by applicable direct marketing laws. Please see the section titled \u{201c}Marketing\u{201d} below for further information about our marketing activities and regarding your right to opt out."
    var tp_4_3_strong = "Marketing."
    var tp_4_2 = "We may process your personal information in order to detect and prevent fraud, and to carry out security vetting, on the legal basis that we have a legitimate interest to do so."
    var tp_4_2_strong = "Security and fraud prevention."
    var tp_4_1_outro = "Accordingly, your failure to provide your personal information in relation to the above services may hinder or prevent us from providing our services to you."
    var tp_4_1_d = "to customise our services to you."
    var tp_2_4 = "the types of personal information you keep on your electronic devices;"
    var tp_2_3 = "details of your employment or work sector;"
    var tp_2_2 = "your age range and gender;"
    var tp_2_1 = "your contact details (such as your name and email address);"
    var tp_2 = "When you do business with us or register for our services we collect certain personal information from you including:"
    var tp_2_strong = "Information we collect from you."
    var tp_1 = "For the purposes of data protection legislation, the \u{201c}controller\u{201d} is Zen Risk Limited (trading as DynaRisk) incorporated in England and Wales under company number 09052805 and having its registered office address at 71-75 Shelton Street, Covent Garden, London, WC2H 9JQ, i.e. this is the company who is responsible for, and controls the processing of, your personal data (\u{201c}we\u{201d}). If you would like to contact us in relation to this Policy please send an email to "
    var tp_1_strong = "About us."
    var tp_intro = "We take your privacy very seriously. Please read this privacy statement (\u{2018}Policy\u{2019}) carefully as it contains important information about how your personal information will be used."
    var tp_last_revision = "Date of last revision: {{date}}"
    var terms_of_service_and_privacy_policy = "Terms - Privacy"
    var privacy_and_cookie_policy = "Privacy and Cookie Policy"
    var server_error = "Oops...we can't connect to the server right now. Please try again later"
    var wrong_password = "Sorry, that's the wrong password"
    var permanently_delete_an_account = "Enter your password to permanently delete your account"
    var exit_cyber_risk_assessment = "Exit Cyber Risk Assessment"
    var view_more = "View more"
    var view_less = "View less"
    var terms_and_conditions = "Terms & Conditions"
    var accept_and_continue = "Accept and continue"
    var decline = "Decline"
    var terms_14_6 = "These terms are governed by English law and you can bring legal proceedings in respect of the Service or Amended Service in the English courts. If you live in Scotland you can bring legal proceedings in respect of the Service or Amended Service in either the Scottish or the English courts. If you live in Northern Ireland you can bring legal proceedings in respect of the Service or Amended Service in either the Northern Irish or the English courts."
    var terms_14_6_strong = "Which laws apply to this contract and where you may bring legal proceedings?"
    var terms_14_5 = "If we do not insist immediately that you do anything you are required to do under these terms, or if we delay in taking steps against you in respect of your breaking this contract, that will not mean that you do not have to do those things and it will not prevent us from taking steps against you at a later date. For example, if you miss a payment and we do not chase you but we continue to provide the Service or Amended Service, we can still require you to make the payment at a later date."
    var terms_14_5_strong = "Even if we delay in enforcing this contract, we can still enforce it later."
    var terms_14_4 = "Each of the paragraphs of these terms operates separately. If any court or relevant authority decides that any of them are unlawful, the remaining paragraphs will remain in full force and effect."
    var terms_14_4_strong = "If a court finds part of this contract illegal, the rest will continue in force."
    var terms_14_3 = "This contract is between you and us. No other person shall have any rights to enforce any of its terms."
    var terms_14_3_strong = "Nobody else has any rights under this contract (except someone you pass your guarantee on to)."
    var terms_14_2 = "You may only transfer your rights or your obligations under these terms to another person if we agree to this in writing. We may not agree."
    var terms_14_2_strong = "You need our consent to transfer your rights to someone else (except that you can always transfer our guarantee)."
    var terms_14_1 = "We may transfer our rights and obligations under these terms to another organisation. We will contact you to let you know if we plan to do this. If you are unhappy with the transfer you may contact us to end the contract within 30 days of us telling you about it and we will refund you any payments you have made in advance for Service or Amended Service not provided."
    var terms_14_1_strong = "We may transfer this agreement to someone else."
    var terms_14_strong = "Other important terms"
    var terms_13 = "Please see our"
    var terms_13_strong = "How we may use your personal information."
    var terms_12_3 = "We only supply the Service or Amended Service for domestic and private use. If you use the Service or Amended Service for any commercial, business or resale purpose we will have no liability to you for any loss of profits, loss of business, business interruption, or loss of business opportunity."
    var terms_12_3_strong = "We are not liable for business losses."
    var terms_12_2_strong_1 = "In all other cases, and in so far as is permitted by law, we will not be responsible to you for any damages or other compensatory payments to you of more than the price you have paid us for the Services."
    var terms_12_2 = "This includes liability for death or personal injury caused by our negligence or the negligence of our employees, agents or subcontractors; for fraud or fraudulent misrepresentation; for breach of your legal rights in relation to the Service or Amended Service as summarised at clause 10.2."
    var terms_12_2_strong = "We do not exclude or limit in any way our liability to you where it would be unlawful to do so."
    var terms_12_1 = "If we fail to comply with these terms, we are responsible for loss or damage you suffer that is a foreseeable result of our breaking this contract or our failing to use reasonable care and skill. Loss or damage is foreseeable if either it is obvious that it will happen or if, at the time the contract was made, both we and you knew it might happen, for example, if you discussed it with us during the sales process."
    var terms_12_1_strong = "We are responsible to you for foreseeable loss and damage caused by us."
    var terms_12_strong = "Our responsibility for loss or damage suffered by you"
    var terms_11_5 = "If you think an invoice is wrong please contact us promptly to let us know. You will not have to pay any interest until the dispute is resolved. Once the dispute is resolved we will charge you interest on correctly invoiced sums from the original due date."
    var terms_11_5_strong = "What to do if you think an invoice is wrong."
    var terms_11_4 = "We accept payment with Visa, MasterCard and American Express. You must pay us in full before we supply any services to you."
    var terms_11_4_strong = "When you must pay and how you must pay."
    var terms_11_3 = "It is always possible that, despite our best efforts, some of the services we provide may be incorrectly priced. We will normally check prices before accepting your order so that, where the Service or Amended Service correct price at your order date is less than our stated price at your order date, we will charge the lower amount. If the Service or Amended Service correct price at your order date is higher than the price stated to you, we will contact you for your instructions before we accept your order."
    var terms_11_3_strong = "What happens if we got the price wrong?"
    var terms_11_2 = "If the rate of VAT changes between your order date and the date we supply the Service or Amended Service, we will adjust the rate of VAT that you pay, unless you have already paid for the Service or Amended Service in full before the change in the rate of VAT takes effect."
    var terms_11_2_strong = "We will pass on changes in the rate of VAT."
    var terms_11_1 = "The price of the Service or Amended Service (which includes VAT) will be the price indicated on the order pages when you placed your order. We take all reasonable care to ensure that the price of the Service or Amended Service advised to you is correct. However please see clause 11.3 for what happens if we discover an error in the price of the Service or Amended Service you order."
    var terms_11_1_strong = "Where to find the price for the Service or Amended Service."
    var terms_11_strong = "Price and payment"
    var terms_rights_2 = "See also Exercising your right to change your mind (Consumer Contracts Regulations 2013)."
    var terms_rights_c = "If you haven't agreed a time beforehand, it must be carried out within a reasonable time."
    var terms_rights_b = "If you haven't agreed a price beforehand, what you're asked to pay must be reasonable."
    var terms_rights_a = "You can ask us to repeat or fix a service if it's not carried out with reasonable care and skill, or get some money back if we can't fix it."
    var services = "services"
    var terms_rights_1_2 = "the Consumer Rights Act 2015 says:"
    var terms_rights_1_1 = "If your product is"
    var terms_rights_1 = "This is a summary of your key legal rights. These are subject to certain exceptions. For detailed information please visit the Citizens Advice website www.adviceguide.org.uk or call 03454 04 05 06."
    var terms_rights = "SUMMARY OF YOUR KEY LEGAL RIGHTS:"
    var terms_10_2 = "We are under a legal duty to supply services that are in conformity with this contract. See the box below for a summary of your key legal rights in relation to the product. Nothing in these terms will affect your legal rights."
    var terms_10_2_strong = "Summary of your legal rights."
    var terms_10_1 = "If you have any questions or complaints about the Service or Amended Service, please contact us. You can write to us info@dynarisk.com."
    var terms_10_1_strong = "How to tell us about problems."
    var terms_10 = "If there is a problem with the Service or Amended Service"
    var terms_9_1 = "We may write to you to let you know that we are going to stop providing the Service or Amended Service. We will let you know at least 30 days in advance of our stopping the supply of the Service or Amended Service and will refund any sums you have paid in advance for any part(s) of the Service or Amended Service which will not be provided."
    var terms_9_strong_1 = "We may withdraw the Service or Amended Service."
    var terms_9_strong = "Our rights to end the contract"
    var terms_8_4 = "We will contact you in advance to tell you we will be suspending the supply of the Service or Amended Service unless the problem is urgent or an emergency. If we have to suspend the Service or Amended Service for longer than 24 hours in any 72 hour period we will adjust the price so that you do not pay for Service or Amended Service while it is suspended. You may contact us to end the contract for the Service or Amended Service if we suspend it, or tell you we are going to suspend it, in each case for a period of more than 24 hours and we will refund any sums you have paid in advance for the Service or Amended Service in respect of the period after you end the contract."
    var terms_8_4_strong = "Your rights if we suspend the supply of the Service or Amended Service."
    var terms_8_3_c = "make changes to the Service or Amended Service as requested by you or notified by us to you (see clause 5)."
    var terms_8_3_b = "update the Service or Amended Service to reflect changes in relevant laws and regulatory requirements;"
    var terms_8_3_a = "deal with technical problems or make minor technical changes;"
    var terms_8_3 = "We may have to suspend the supply of the Service or Amended Service to:"
    var terms_8_3_strong = "Reasons we may suspend the supply of the Service or Amended Service to you."
    var terms_8_2_1 = ". If you do not provide this all of this information we will not be able to provide the Service or Amended Service. We will not be responsible for supplying the Service or Amended Service late or not supplying all or any part of the Service or Amended Service if this is caused by you not giving us the information we need within a reasonable time of us asking for it."
    var terms_8_2 = "We need certain information from you so that we can supply the Service or Amended Service to you. The information needed is listed in our"
    var terms_8_2_strong = "What will happen if you do not give required information to us."
    var terms_8_1 = "If our supply of the Service or Amended Service is delayed by an event outside our control then we will contact you as soon as possible to let you know and we will take steps to minimise the effect of the delay. Provided we do this we will not be liable for delays caused by the event, but if there is a risk of substantial delay you may contact us to end the contract and receive a refund for any Service or Amended Service you have paid for but not received."
    var terms_8_1_strong = "We are not responsible for delays outside our control."
    var terms_8 = "We will supply the Service or Amended Service to you until either the Service or Amended Service is completed or the subscription expires (if applicable) or you end the contract as described in clause 7 or we end the contract by written notice to you as described in clause 9."
    var terms_8_strong_1 = "When we will provide the Service or Amended Service."
    var terms_8_strong = "Providing the Service or Amended Service"
    var terms_7_4 = "We will make any refunds due to you as soon as possible. If you are exercising your right to change your mind then your refund will be made within 14 days of your telling us you have changed your mind."
    var terms_7_4_strong = "When your refund will be made."
    var terms_7_3_a = "We may deduct from any refund an amount for the supply of the Service or Amended Service for the period for which it was supplied, ending with the time when you told us you had changed your mind. The amount will be in proportion to what has been supplied, in comparison with the full coverage of the contract."
    var terms_7_3 = "If you are exercising your right to change your mind:"
    var terms_7_3_strong = "Deductions from refunds if you are exercising your right to change your mind."
    var terms_7_2 = "We will refund you the price you paid for the Service or Amended Service, by the method you used for payment. However, we may make deductions from the price, as described below."
    var terms_7_2_strong = "How we will refund you."
    var terms_7_1_a = "Call customer services on +44 (0)203 086 8875 or email us at info@dynarisk.com. Please provide your name, home address, details of the order and, where available, your phone number and email address."
    var terms_7_1_a_strong = "Phone or email."
    var terms_7_1 = "To end the contract with us, please let us know by doing one of the following:"
    var terms_7_1_strong = "Tell us you want to end the contract."
    var terms_7_strong = "How to end the contract with us (including if you have changed your mind)"
    var terms_6_5_a = "If so, you have 14 days after the day we email you to confirm we accept your order. However, once we have completed the Service or Amended Service you cannot change your mind, even if the period is still running. If you cancel after we have started the Service or Amended Service, you must pay us for the Service or Amended Service provided up until the time you tell us that you have changed your mind."
    var terms_6_5_a_strong = "Have you bought services?"
    var terms_6_5 = "How long you have depends on what you have ordered and how it is delivered."
    var terms_6_5_strong = "How long do I have to change my mind?"
    var terms_6_4_a = "services, once these have been completed, even if the cancellation period is still running;"
    var terms_6_4 = "You do not have a right to change your mind as far as is relevant in respect of:"
    var terms_6_4_strong = "When you don't have the right to change your mind."
    var terms_6_3 = "For most products bought online you have a legal right to change your mind within 14 days and receive a refund. These rights, under the Consumer Contracts Regulations 2013, are explained in more detail in these terms."
    var terms_6_3_strong = "Exercising your right to change your mind (Consumer Contracts Regulations 2013)."
    var terms_6_2_e = "you have a legal right to end the contract because of something we have done wrong, including because we have delivered late."
    var terms_6_2_d = "we have suspended supply of the Service or Amended Service for technical reasons, or notify you we are going to suspend them for technical reasons, in each case for a period of more than 24 hours; or"
    var terms_6_2_c = "there is a risk that supply of the Service or Amended Service may be significantly delayed because of events outside our control;"
    var terms_6_2_b = "we have told you about an error in the price or description of the Service or Amended Service you have ordered and you do not wish to proceed;"
    var terms_6_2_a = "we have told you about an upcoming change to the Service or Amended Service or these terms which you do not agree to;"
    var terms_6_2 = "If you are ending a contract for a reason set out at (a) to (e) below the contract will end immediately and we will refund you in full for any Service or Amended Service which have not been provided and you may also be entitled to compensation. The reasons are:"
    var terms_6_2_strong = "Ending the contract because of something we have done or are going to do."
    var terms_6_1_c = "clause 7.3. You may be able to get a refund if you are within the cooling-off period, but this may be subject to deductions."
    var terms_6_1_c_strong = "If you have just changed your mind about the Service or Amended Service, see"
    var terms_6_1_b_strong = "If you want to end the contract because of something we have done or have told you we are going to do, see"
    var terms_6_1_a_1 = "clause 10;"
    var terms_6_1_a_strong_1 = "see"
    var terms_6_1_a = "(or a service re-performed or to get some or all of your money back),"
    var terms_6_1_a_strong = "If what you have bought is faulty or misdescribed you may have a legal right to end the contract"
    var terms_6_1 = "Your rights when you end the contract will depend on what you have bought, whether there is anything wrong with it, how we are performing and when you decide to end the contract:"
    var terms_6_1_strong = "You can always end your contract with us."
    var terms_6_strong = "Your rights to end the contract"
    var terms_5_additional = "These changes should not have a detrimental affect your use of the Service or Amended Service."
    var terms_5_1_b = "to implement technical adjustments and improvements."
    var terms_5_1_a = "to reflect changes in relevant laws and regulatory requirements ; and"
    var terms_5_1 = "We may change the Service or Amended Service:"
    var terms_5_1_strong = "Changes to the Service or Amended Service."
    var terms_5_strong = "Our rights to make changes"
    var terms_4_1 = "If you wish to make a change to the Service please contact us immediately. We will let you know if the change is possible. If it is possible we will let you know about any changes to the price of the amended service    <strong>(Amended Service)</strong>&nbsp; the timing of supply or anything else which would be necessary as a result of your requested change and ask you to confirm whether you wish to go ahead with the change. If we cannot make the change or the consequences of making the change are unacceptable to you, you may want to end the contract (see clause 7)."
    var terms_4_strong = "Your rights to make changes."
    var terms_3_3_7 = "We rely on you answering our questions fully and honestly to allow us to assess and deliver to you an accurate security score and action list. If you do not do so, your cyber risk may not be lowered."
    var terms_3_3_6 = "We may provide you actions that encourage you to upgrade old or out of date hardware and software, but any costs associated with the upgrading we suggest is your responsibility; and"
    var terms_3_3_5 = "We do not pay to obtain stolen data and neither will we negotiate on your behalf for the return of stolen data;"
    var terms_3_3_4 = "We work hard to gather as much stolen information as possible to help keep you safe but we cannot guarantee we are able to obtain all stolen data on you;"
    var terms_3_3_3 = "Some emails sent from DynaRisk could be marked as spam by your email provider, if you have not received an email that you are expecting from us, please check your spam folder;"
    var terms_3_3_2 = "Completing all actions in the DynaRisk system will lower your risk but this does not guarantee you will not suffer a security breach. If you do not complete your actions in the DynaRisk system, your risk will not be lowered;"
    var terms_3_3_1 = "Our vulnerability scan checks for the most common vulnerabilities in Web Browsers and Browser Plugins, however it does not check for all vulnerabilities and so we do not guarantee to find all vulnerabilities inall types of software;"
    var terms_3_3 = "Our contract with you"
    var terms_3_3_strong = "What we are not promising to provide you and some other points you should know."
    var terms_3_2 = "If we are unable to accept your order, we will inform you of this and will not charge you for the Service. This might be because of unexpected limits on our resources which we could not reasonably plan for, because we have identified an error in the price or description of the Service or because we are unable to meet a delivery deadline you have specified."
    var terms_3_2_strong = "If we cannot accept your order."
    var terms_3_1_2 = "you have asked us to provide you and we have agreed to provide you."
    var terms_3_1_service_strong = "(Service)"
    var terms_3_1_1 = "Our acceptance of your order will take place when we email you a receipt for your purchase, at which point a contract will come into existence between you and us. This email will confirm the service"
    var terms_3_1_strong = "How we will accept your order."
    var terms_3_strong = "Our contract with you"
    var terms_2_4 = "When we use the words \"writing\" or \"written\" in these terms, this includes emails."
    var terms_2_4_strong = "\"Writing\" includes emails."
    var terms_2_3 = "If we have to contact you we will do so by telephone or by writing to you at the email address or postal address you provided to us in your order."
    var terms_2_3_strong = "How we may contact you."
    var terms_2_2 = "You can contact us by writing to us at"
    var terms_2_2_strong = "How to contact us."
    var terms_2_1 = "We are Zen Risk Limited a company registered in England and Wales. Our company registration number is 09052805 and our registered office is at 71-75 Shelton Street, Covent Garden, London WC2H 9JQ. Our registered VAT number is 202 0071 88"
    var terms_2_1_strong = "Who we are."
    var terms_2_strong = "Information about us and how to contact us"
    var terms_1_3_2 = " both of which apply to your legal relationship with us."
    var terms_1_3_1 = "Other You should also read our."
    var terms_1_3_strong = "Other documents."
    var terms_1_2 = "Please read these terms carefully before you submit your order to us. These terms tell you who we are, how we will provide services to you, how you and we may change or end the contract, what to do if there is a problem and other important information. If you think that there is a mistake in these terms, please contact us to discuss."
    var terms_1_2_strong = "Why you should read them."
    var terms_1_1 = "These are the terms and conditions on which we supply services to you."
    var terms_1_1_strong = "What these terms cover."
    var terms_1_strong = "These terms"
    var you_have_been_automaticly_logout = "You have been logged out of your account because your session has expired"
    var invalid_credit_card_number = "Invalid credit card number"
    var plan_feature_support_type_premium = "Premium Support"
    var plan_feature_support_type_enhanced = "Enhanced Support"
    var plan_feature_support_type_standard = "Standard Support"
    var plan_status_success = "Order paid successfully. Your account is now on the {{plan}}"
    var plan_feature_description_vulnerability_scan = "We scan your applications, operating system and plugins to check for vulnerabilities that may leave you at risk of cyber attack."
    var plan_feature_description_virus_removal = "Our expert support team can remove a number of viruses from your devices, giving you peace of mind."
    var plan_feature_description_cyber_restorations_services = "Worried about a suspicious email you just received, or fear you may have been hacked? Let our expert support team investigate and propose next steps."
    var plan_feature_description_router_scan = "We scan your router to make sure cyber criminals can't access it, or your home network."
    var plan_feature_description_phishing_simulator = "Avoid falling victim to scams like phishing, ransom and push payment fraud by learning how to spot them and get alerts on new and emerging scams that could defraud you."
    var plan_feature_description_threats_alerts = "Receive new alerts direct to your inbox helping you to stay up to date on the latest cyber security threats."
    var plan_feature_description_support_type = "Get access to our expert support team who can provide advice and assistance for all things cyber related."
    var plan_feature_description_max_devices = "We scan your devices to see if they have vulnerabilities that would leave you open to hacking."
    var plan_feature_description_max_family_and_friends = ""
    var plan_feature_description_family_and_friends = "We monitor for your personal data being shared by cyber criminals or leaked by unsecured websites across hundreds of data sources around the world. Find out more about how we source stolen data."
    var plan_feature_description_max_user_emails = "We monitor for your personal data being shared by cyber criminals or leaked by unsecured websites across hundreds of data sources around the world. Find out more about how we source stolen data."
    var plan_feature_description_personalised_improvement_plan = "Over 125 possible actions designed to help improve your score. Based on your personal assessment, we will provide an ongoing action plan to help improve and maintain your Cyber Security Score."
    var plan_feature_description_cyber_security_score_and_report = "Get a complete overview of your digital security along with a tailored simple step by step plan for how to improve it."
    var assessment_footer = "The information you provide is confidential and will not be shared with third parties."
    var plan_ultimate_description = "Protect your family and all your devices with our Ultimate home plan."
    var plan_advantage_description = "Advanced protection for individuals with a larger digital footprint."
    var plan_standard_description = "Basic protection to help keep you safe from common threats."
    var protected_data_verify_your_protected_data = "Verify your protrcted data"
    var protected_data_verifying = "Verifying token..."
    var protected_data_phone_is_now_activated = "Phone is now activated"
    var protected_data_phone_activation_error = "Phone activation error"
    var protected_data_email_is_now_activated = "Email is now activated"
    var protected_data_email_activation_error = "Email activation error"
    var is_family_member = "This is a family member's email"
    var i_have_completed_this_action = "I have completed this action"
    var mark = "Mark"
    var first_show_action_reminder = "You should first read this action, before you mark it as done"
    var device_activate = "activate device"
    var device_device_activated = "device activated"
    var device_sure_delete_device = "I'm sure delete device"
    var device_delete_device = "delete device"
    var device_delete_warning = "Are you sure you want to delete this device?"
    var device_add_device = "Add device"
    var device_add_device_name = "Add device name"
    var devices_list_activate_device = "activate device"
    var device_choose_operating_system = "Choose operating system"
    var device_add_new_device = "Add a new device"
    var emails_delete_delete_email = "Delete email"
    var to_do_task_error_loading = "Error while loading actions..."
    var sidebar_download_app_reassignment = "Download app for easier reassignment"
    var sidebar_download_app = "Download"
    var sidebar_manage_data = "Add data"
    var monitored_data_phone_numbers = "Phone numbers"
    var monitored_data_credit_cards = "Credit cards"
    var i_need_help_completing_an_action_descr = "If you are having trouble with a suggested action, our support team are here to help. Let us know which action(s) you need help with and we'll talk you through it."
    var i_need_help_completing_an_action = "I need help completing an action"
    var i_have_a_billing_issue_descr = "If you are having payment issues, or have a query about a transaction, please contact us."
    var i_have_a_billing_issue = "I have a billing issue"
    var i_have_a_problem_with_my_account_descr = "If you are experiencing any issues with your account, or need some help using your {{name}} dashboard, please get in touch."
    var i_have_a_problem_with_my_account = "I have a problem with my account"
    var i_think_i_ve_been_hacked_descr = "If you think you may have been hacked, or targeted by cyber criminals, contact us right away. Please include as much detail as possible as this will help us to resolve your query quickly and efficiently. Any information you provide is confidential and will not be shared."
    var i_think_i_ve_been_hacked = "I think I've been hacked"
    var plan_status_error = "Order paid failure."
    var working_hours = "Working hours"
    var replies_in_24 = "Typically replies in 24 hours"
    var email_us = "Email us"
    var one_year = "1 Year"
    var vip_plan = "VIP plan"
    var ultimate = "Ultimate plan"
    var advantage = "Advantage plan"
    var standard = "Standard plan"
    var plan = "plan"
    var special_characters = "Special Characters"
    var numbers = "Numbers"
    var lowercase = "Lowercase"
    var uppercase = "Uppercase"
    var x_characters = "{{number}} characters"
    var billing = "Billing"
    var email_settings = "Email Settings"
    var plans = "Plans"
    var profile = "Profile"
    var find_a_solution = "FIND A SOLUTION RIGHT NOW"
    var faq = "FAQ"
    var card_must_contains = "Credit cards should only contains 12 to 16 digits."
    var phone_must_contains = "Phone number must contains 5 to 14 Numbers"
    var can_t_get_tasks = "Can't get actions list"
    var can_t_change_email = "Can't change email"
    var email_cahnged = "Email successfully changed to {{ email }}"
    var profile_deleted = "Profile successfully deleted"
    var can_t_delete_profile = "Can't delete profile. Please try again later"
    var can_t_delete_account = "Can't delete account. Please try again later"
    var can_t_save_answer = "Can't save answer. Please try again later"
    var assessment_reset_error = "Can't reset assessment score. Please try again later"
    var assessment_reseted = "Assessment reseted"
    var device_assessment_subheader = "Device assessment questions will help us to understand how secure your devices are and any risks that may leave them vulnerable to a security breach."
    var device_assessment = "Device assessment"
    var complete_device_assessment = "Complete assessment"
    var an_error_occured = "An error occured. Please try again later"
    var password_strength_error = "Password is not so strong as needed"
    var password_repeat_error = "Repeated password is not the same"
    var password_change_error = "Can't edit password. Please try again later"
    var password_changed = "Password successfully changed"
    var can_t_show_payment_history = "Can't show payments history. Try again later"
    var required = "Required"
    var device_activation_error = "Can't activate your device. Please try again later"
    var device_is_now_activated = "Device is now activated"
    var get_phones_error = "Can't get phones. Please try later"
    var add_phone_error = "Can't add phone number. Please try later"
    var phone_added = "Phone number successfully added"
    var email_delete_error = "Can't delete email {{email}}. Please try again later"
    var email_deleted = "{{email}} email successfully deleted"
    var get_emails_error = "Can't add email. Please try later"
    var add_email_error = "Can't add email. Please try later"
    var email_is_added = "Email successfully added"
    var field_is_required = "A field is required"
    var can_t_select_features = "Can't select features"
    var coupon_not_applied = "The coupon not applied"
    var coupon_is_applied = "Discount Promo code applied"
    var activation_link_error = "Can't send activation link. Please try again later"
    var delete_credit_card_error = "Can't delete credit card {{card}}. Please try again later"
    var phone_number_is_deleted = "{{phone}} phone number is successfully deleted"
    var credit_card_is_deleted = "{{card}} credit card successfully deleted"
    var get_credit_cards_error = "Can't get credit cards. Please try later"
    var add_credit_card_error = "Can't add credit card. Please try later"
    var credit_card_is_added = "Credit card successfully added"
    var can_t_get_plans = "Can't get plans"
    var device_delete_error = "Can't delete device {{title}} - {{name}}. Please try again later"
    var device_was_deleted = "Device {{title}} - {{name}} was successfully deleted"
    var can_t_fetch_devices = "Can't fetch devices. Please try again later"
    var can_t_add_device = "Can't add device. Please try again later"
    var deleting_credit_card_error = "An error occurred while deleting credit card"
    var verification_is_resent = "Verification is resent to {{email}}"
    var can_t_resend_email = "Can't resend email"
    var can_t_select_plan = "Can't select plan"
    var can_t_change_personal_info = "can't change personal information. Please try again later"
    var personal_info_changed = "Personal info successfully changed"
    var cvv_is_required = "CVV is required"
    var enter_valid_cvv = "Please enter valid CVV"
    var year_is_required = "Year is required"
    var enter_valid_year = "Please enter valid year"
    var month_is_required = "Month is required"
    var country_code_is_required = "Country code is required"
    var enter_valid_phone_number = "Please enter valid phone number"
    var enter_valid_month = "Please enter valid month number"
    var card_number_is_required = "Card number is required"
    var enter_valid_card_number = "Please enter valid card number"
    var last_name_invalid = "Last name \u{0441}ontains invalid characters"
    var first_name_invalid = "First name \u{0441}ontains invalid characters"
    var last_name_is_required = "Last name is required"
    var first_name_is_required = "First name is required"
    var enter_valid_name = "Please enter valid name"
    var enter_valid_email = "Please enter valid email"
    var recovery_email_is_required = "Recovery Email address is required"
    var email_is_required = "Email address is required"
    var passwords_doesn_t_match = "Passwords doesn't match"
    var confirmation_password_is_required = "Confirmation password is required"
    var password_is_required = "Password is required"
    var tour_mobile_description_4 = "Manage devices, access your to-do list and find support from the nav menu."
    var tour_mobile_title_4 = "Access a range of tools using the nav menu"
    var tour_mobile_description_3 = "Our database contains over 14.5 billion pieces of stolen data. Scan your email addresses to check if they have ever been breached."
    var tour_mobile_title_3 = "Add additional email addresses and scan them against our database"
    var tour_mobile_description_2 = "Add mobiles, PCs, laptops and tablets to make sure your devices are protected."
    var tour_mobile_title_2 = "Add additional devices and scan them for vulnerabilities"
    var tour_mobile_description_1 = "Your score moves up and down depending on your cyber security risk. Complete actions to improve your score."
    var tour_mobile_title_1 = "Keep an eye on your Cyber Security Score"
    var tour_desktop_description_5 = "If you have any questions, concerns or would like help completing an action, our support team are always on hand."
    var tour_desktop_title_5 = "Contact us for support"
    var tour_desktop_description_4 = "Our database contains billions of pieces of stolen data. Scan all your email addresses to check if they have ever been breached."
    var tour_desktop_title_4 = "Find out if your personal information has been breached: add all of your email addresses and scan them against our database"
    var tour_desktop_description_3 = "Add mobile phones, PCs, laptops and tablets to make sure your devices are protected."
    var tour_desktop_title_3 = "Add additional devices and scan them for vulnerabilities"
    var tour_desktop_description_2 = "Discover any outstanding actions required to help improve your Cyber Security Score."
    var tour_desktop_title_2 = "Complete actions in the to-do section to improve your score"
    var tour_desktop_description_1 = "Your score moves up and down as we continuously assess your digital footprint. Complete actions to improve your score."
    var tour_desktop_title_1 = "Keep an eye on your cyber security score"
    var finish = "finish"
    var skip_tour = "skip tour"
    var next = "next"
    var to_do_filter_scorecard_default = "Default"
    var to_do_filter_scorecard_practises = "Practises"
    var to_do_filter_scorecard_social_engineering = "Social engineering"
    var to_do_filter_scorecard_inappropriate_software = "Inappropriate software"
    var to_do_filter_scorecard_parental_controls = "Parental controls"
    var to_do_filter_scorecard_backup = "Backup"
    var tp_4_1_c = "to carry out billing and administration activities;"
    var tp_4_1_b = "to provide our services;"
    var tp_4_1_a = "to process your registration and identify you;"
    var tp_4_1 = "We may process your personal information for the following purposes on the legal basis that it is necessary for us to provide our services to you:"
    var tp_4_1_strong = "Necessary processing."
    var tp_4_strong = "Purposes and legal bases of processing."
    var tp_3 = "Where you use our services as a result of your employer\u{2019}s corporate subscription, we may receive personal information about you from your employer, for example your contact details. In providing you with an online security score, and to help protect you against fraud, we may cross check your personal information against data that is already available online in the public domain (for example on the internet or the \u{201c}deep web\u{201d}). This is to check whether your details may have been published online as a result of a past data breach."
    var tp_3_strong = "Information about you from other sources."
    var tp_2_7 = "other personal aspects for us to calculate your online security score."
    var tp_2_6 = "other information in relation to your use of electronic devices (for example as part of our services we may scan your devices for security vulnerabilities and out of date software);"
    var tp_2_5 = "the types of activities you carry out online (for example, transactions, socialising and storing content);"
    var to_do_filter_scorecard_privacy_controls = "Privacy controls"
    var to_do_filter_scorecard_password_management = "Password management"
    var to_do_filter_scorecard_encryption = "Encryption"
    var to_do_filter_scorecard_security_software = "Security software"
    var to_do_filter_completed = "Completed"
    var to_do_filter_to_be_completed = "To be completed"
    var to_do_filter_information = "Information"
    var to_do_filter_all_risk = "All"
    var to_do_filter_low_risk = "Low risk"
    var to_do_filter_medium_risk = "Medium risk"
    var to_do_filter_very_high_risk = "Very high risk"
    var to_do_filter_high_risk = "High risk"
    var to_do_filter_priority = "Priority"
    var qrcode_scan = "Scan this with you mobile device"
    var the_laptop_you_added_not_active = "The laptop you added is not active yet"
    var payment_history = "Payment History"
    var device_tasks = "Device Actions"
    var what_we_scan = "What we\u{2019}re scanning for"
    var scan_label = "{{label}}"
    var passwords_must_contain_a_combination_of = "Passwords must contain a combination of 12 characters using uppercase & lowercase, numbers and special characters."
    var edit_email = "Edit Email"
    var success = "Success"
    var requesting = "Requesting..."
    var payment_method = "Payment Method"
    var via_credit_card = "Via Credit Card"
    var problems = "Problems"
    var privacy_policy = "Privacy Policy"
    var terms_and_privacy = "Terms and privacy"
    var vulneralilities_scan = "Vulnerability Scans"
    var vulneralilities_found_subheader = "You\u{2019}re at high security risk, login to your dahsboard to fix it"
    var vulneralilities_found_header = "Vulnerabilities Found"
    var add_discount_subheader = "If you have a discount code, or a code which entitles you to a free trial, add it now."
    var don_t_have_a_code = "I don't have a code"
    var add_discount = "Add discount code"
    var verify_your_device = "Verify your device"
    var device_not_verified = "Device not verified"
    var device_verified = "Device verified successfully"
    var device_verifying = "Device verifying"
    var logged_out_successfully = "Logged out successfully"
    var loading_device = "loading device"
    var loading_action = "Loading action..."
    var loading_actions = "Loading actions..."
    var loading = "loading"
    var loading_assessment = "Loading assessment"
    var loading_plans = "loading plans"
    var changing_password = "changing password"
    var error_occured = "error occured"
    var confirm_password = "Confirm password"
    var sign_up_with_facebook = "Sign up with Facebook"
    var enter_a_password = "Enter a password"
    var recovery_email = "Recovery Email"
    var enter_your_name = "Enter your name"
    var got_an_account = "go an account?"
    var sign_in_with_facebook = "Sign in with Facebook"
    var forgot_password = "forgot password"
    var delete_phone_warning = "Are you sure you want to delete this phone number?"
    var delete_card_warning = "Are you sure you want to delete this credit card?"
    var delete_emails_warning = "Are you sure you want to delete this email?"
    var protected_emails_description = "We monitor the email addresses you add to check if they've been leaked or stolen."
    var protected_emails = "Protected emails"
    var add_card = "Add card"
    var delete_phone_number = "Delete phone number"
    var delete_credit_card = "Delete credit card"
    var protected_phone_description = "We monitor the phone numbers you add to check if they've been leaked or stolen."
    var protected_phone_numbers = "Protected phone numbers"
    var protected_cards_description = "We monitor the credit card numbers you add to check if they've been leaked or stolen."
    var protected_cards = "Protected cards"
    var monitor_data = "Monitor Data"
    var add_device = "Add Device"
    var add_phone = "Add phone"
    var add_phone_number = "Add phone number"
    var add_credit_card = "Add credit card"
    var disabled_upgrade_plan_to_enable_device = "Disabled - upgrade plan to enable device"
    var add_email = "add email"
    var cvv = "CVV"
    var expiry_year = "Expiry year"
    var expiry_month = "Expiry month"
    var last_name = "Last Name"
    var first_name = "First Name"
    var full_name = "Full Name"
    var name_your_device = "Name your device"
    var search_apps = "Search apps that enables 2 Step Verification"
    var enable_2_step_verification = "Enable 2 Step Verification"
    var email_already_verified = "Email already verified"
    var email_verified = "Email verified successfully"
    var email_verifying = "Email verifying"
    var we_sent_an_activation_email_subheader = "Check your email for activation link"
    var we_sent_an_activation_email_header = "We sent you an activation email"
    var an_activation_link_has_been_sent = "An activation link has been sent to your email address. Please click on the link to verify your email address and continue with the registration process."
    var verify_your_email_header = "Verify your email"
    var maybe_later = "Maybe later"
    var upgrade_plan = "upgrade plan"
    var enable_scan = "enable scan"
    var disabled = "Disabled"
    var enabled = "Enabled"
    var start_scan = "Start scan"
    var run_some_scans_to_check = "We will now run some scans to check for vulnerabilities and potential cyber security risks."
    var your_cyber_security_score_tip_dashboard = "Your score improves every time you finish a action. Start completing actions and reduce your risk!"
    var your_cyber_security_score_tip = "Your score improves every time you finish a action. You have to have at least 800 to be secured online."
    var risk_excellent = "You are at very low risk of fraud, cyber crime and privacy breaches."
    var risk_very_good = "You are at low risk of fraud, cyber crime and privacy breaches."
    var risk_good = "You are at moderate risk of fraud, cyber crime and privacy breaches."
    var risk_fair = "You are at high risk of fraud, cyber crime and privacy breaches."
    var risk_very_poor = "You are at very high risk of fraud, cyber crime and privacy breaches."
    var risk_medium = "You're at medium risk"
    var your_cyber_security_score = "Your Cyber Security Score"
    var error_loading_devices = "Error while loading devices..."
    var risk_loading_error = "Error while loading your cyber security risk..."
    var risk_loading = "Loading your cyber security risk score..."
    var type_new_password = "Type in your new password"
    var resetting_password_error = "Error while resetting password"
    var reset_password_error = "Error while sending email for resetting password"
    var reset_password_sent_subheader = "If this email has an account in our system you will shortly receive an email with a password reset link valid for 24 hours"
    var reset_and_sign_in = "Reset password and sign in"
    var reset_password_success = "Resetting password success"
    var resetting_password = "Resetting password"
    var reset_your_password = "Reset your password"
    var reset_password_sent = "Email for resetting password sent"
    var reset_password_sending = "Email for resetting password sending"
    var new_to_dynarisk = "new to {{name}}?"
    var general_assessment_subheader = "General assessment questions help us to figure out if your devices and email addresses are at risk of being breached. Based on the information you provide, we can assess how a breach would affect your digital footprint and provide a tailored action plan to help improve your cyber security."
    var general_assessment = "General assessment"
    var email_already_registered = "Unable to use this email- please contact support"
    var are_you_already_registered = "Are you already registered?"
    var are_you_not_registered = "Are you not registered?"
    var sign_in_to_dynarisk_subheader = "Sign in to your {{name}} account to view your dashboard and complete any actions to improve your Cyber Security Score."
    var sign_in_to_dynarisk_facebook_subheader = "Register for your {{name}} account and start protecting yourself from cyber threats."
    var action_data_breach_subheader = "Make sure you are in a private place. The data you are about to see may contain your private sensitive information"
    var action_data_breach_header = "Click here to see your raw breached data"
    var continue_as = "Continue as"
    var delete_account_warning = "You won\u{2019}t be able to undo this action once your account is deleted"
    var reason_for_deleting_your_account = "Please provide a reason for deleting your account"
    var delete_account = "Delete account"
    var router_scan = "Router Scan"
    var vulnerability_scan = "Vulnerability Scan"
    var data_breach_scanner = "Data Breach Scan"
    var security_news = "Security News"
    var special_offers = "Special offers"
    var data_breach_reports = "Email Settings Data Breach Reports"
    var change_payment_method = "Change payment method"
    var about_ssl_certificates = "about ssl certificates"
    var activate_payment_method = "Active payment method"
    var personal_information = "Personal information"
    var vulnerability_alerts = "Vulnerability Alerts"
    var setting = "Settings"
    var phone_is_required = "Phone number is required"
    var message_is_short = "The number of characters must be at least 5"
    var message_is_required = "Message is required"
    var name_is_required = "Name is required"
    var subject_is_required = "Subject is required"
    var message = "Message"
    var send = "Send Message"
    var sign_in_to_dynarisk = "Sign in to {{name}}"
    var welcome_to_dynarisk = "Welcome to {{name}}"
    var sign_up_to_dynarisk = "Sign up to {{name}}"
    var log_out = "log out"
    var sign_in = "Sign in"
    var return_to_sign_in = "Return to Sign In"
    var sign_up = "Sign up"
    var need_more_help = "need more help?"
    var try_trial = "try trial"
    var free = "Free"
    var postponed = "Postponed"
    var overdue = "Overdue"
    var dashboard = "Dashboard"
    var all_devices = "All devices"
    var device_filter_placeholder = "Device"
    var priority_filter_placeholder = "Priority"
    var status_filter_placeholder = "Status"
    var to_do_list_filters = "Filters"
    var devices = "Devices"
    var emails = "Emails"
    var x_tasks = "{{number}} Actions "
    var none = "None "
    var apply_code = "Apply code"
    var remember_me = "Remember me"
    var new_password = "New Password"
    var old_password = "Old Password"
    var repeat_new_password = "Repeat New Password"
    var change_password = "Change password"
    var password = "Password"
    var additional_options_header = "Additional options"
    var steps = "Steps"
    var instructions_header = "Instructions"
    var why_ti_is_necessary = "Why is it absolutely necessary?"
    var data_breaches_scan_subheader = "We're checking our database of over 14.5 billion pieces of stolen data to see if your information has been stolen"
    var data_breaches_scan_header = "Scanning for data breaches"
    var device_vulnerability_subheader = "We're checking your device for vulnerabilities"
    var device_vulnerability_header = "Scanning for vulnerabilities"
    var account_vulnerability_subheader = "We're checking your information and devices for vulnerabilities"
    var account_vulnerability_header = "Scanning for vulnerabilities"
    var performing_a_router_scan_subheader = "We're checking your internet router for vulnerabilities"
    var performing_a_router_scan = "Performing a router scan"
    var support_subheader = "If you need help with your account or think you may have fallen victim to cyber crime, please select one of the options below and we'll be in touch as soon as possible."
    var support = "Contact Support"
    var download_app_subheader = "We will ask you a few questions to evaluate how secure you are online; these questions allow us to know the likelihood of your devices and emails getting breached."
    var can_t_be_activated = "Device cannot be activated. Please login to your dashboard from the device you are attempting to activate and try again."
    var device_limit_reached = "Device limit reached"
    var upgrade_to_add_more_devices = "Upgrade to add more devices"
    var reached_device_limit = "Reached devices limit"
    var error_call_limit = "Request call limit"
    var call_limit = "You reach call limit, please try again later"
    var download_app = "Download App"
    var call_us = "Call us"
    var pending = "pending"
    var active = "Active"
    var actions_tasks = "Actions"
    var to_do = "To Do"
    var how_to_do_it = "how to do it"
    var not_sure = "not sure"
    var yes = "yes"
    var no = "no"
    var save = "save"
    var resend_activation_email = "resend activation email"
    var resend_activation_link = "resend activation link"
    var wrong_os_device = "This operating system is unsupported by {{partner_name}} page"
    var dashboard_copy_the_laptop_you_added_has_been_activated_but_assessment_is_not_answered = "{{device_name}} was added - to activate and monitor your device we must perform a security assessment"
    var dashboard_copy_the_device_you_added_is_active_now = "The device is active now. Cross out items to make the device more secure."
    var dashboard_copy_the_laptop_you_added_has_not_been_activated_yet = "The device you added has not been activated yet"
    var upgrade_plane_pay_contact = "contact"
    var upgrade_plane_standard_select_plan = "select plan"
    var dashboard_tasks_item_remind_later = "remind me later"
    var dashboard_tasks_list_everything_ok = "Everything looks OK!"
    var dashboard_tasks_view_all = "View all actions"
    var dashboard_tasks_what_to_do = "What to do next"
    var monitored_data = "Monitored Data"
    var dashboard_manage_monitored_data = "Manage Data"
    var dashboard_manage_devices = "Manage Devices"
    var dashboard_to_do = "To do"
    var continue_to_dashboard = "Continue to dashboard"
    var dashboard_dashboard = "Dashboard"
    var reset_password = "Reset password"
    var change_email = "Change email"
    var change_plan = "Change plan"
    var continue_ = "Continue"
    var view_device = "View device"
    var cancel = "cancel"
    var name = "Name"
    var email_address = "Email address"
    var card_number = "Card number"
    var credit_card = "credit card"
    var phone_number = "Phone number"
    var protected = "protected"
    var delete = "Delete"
    var add = "add"
    var two_weeks = "Two Weeks"
    var five_days = "Five Days"
    var one_day = "One Day"
    var powered_by = "powered by"
    var month_name_december = "December"
    var month_name_november = "November"
    var month_name_october = "October"
    var month_name_september = "September"
    var month_name_august = "August"
    var month_name_july = "July"
    var month_name_june = "June"
    var month_name_may = "May"
    var month_name_april = "April"
    var month_name_march = "March"
    var month_name_february = "February"
    var month_name_january = "January"
    var day_of_week_sartuday = "Saturday"
    var day_of_week_friday = "Friday"
    var day_of_week_thursday = "Thursday"
    var day_of_week_wednesday = "Wednesday"
    var day_of_week_tuesday = "Tuesday"
    var day_of_week_monday = "Monday"
    var day_of_week_sunday = "Sunday"
    var remind_me_later = "Remind me in:"
    var device_type_laptop = "laptop"
    var device_type_desktop = "desktop"
    var device_type_tablet = "tablet"
    var device_type_phone = "phone"
    var device_type_pc = "PC"
    var confirm_delition_email = "An email has been sent to confirm the deletion of your account"
    var login_enter_login_information = "Enter login information"
    var login_email_address_field_is_empty_ = "Email address field is empty!"
    var login_password_field_is_empty_ = "Password field is empty!"
    var login_errror_occured_while_saving_new_device_please_try_ = "Errror occured while saving new device. Please try again"
    var dashboard_device_not_active = "the {{pc}} you added is not active yet"
    var dashboard_tasks_to_finish_in_order_to_protect_yourself = "Tasks to finish in order to protect yourself"
    var dashboard_you_need_to_complete_all_task_in_order_to_be_prote = "You need to complete all task in order to be protected"
    var dashboard_last_scan_ = "Last scan:"
    var dashboard_issues_count_found = "{{count}} issues found"
    var dashboard_dark_web_scans = "Dark web scans"
    var dashboard_security_scans = "Security scans"
    var dashboard_scam_emails = "Scam Emails"
    var dashboard_device_status = "Device status"
    var devices_1_device = "1 Device"
    var devices_count_devices = "{{count}} Devices"
    var devices_this_device = "this device"
    var devices_resend_verification_email = "resend verification email"
    var devices_this_device_has_not_been_activated_yet = "This device has not been activated yet"
    var devices_check_you_inbox_for_an_email_with_instructions_to_ = "Check you inbox for an email with instructions to activate this device"
    var devices_no_devices = "No Devices"
    var devices_you_have_no_devices_present_tap_the_plus_sign_top_ = "You have no devices present. Tap the plus sign top right to add devices that you wish to protect. Once added follow instructions in order to activate the device"
    var add_device_type = "Device type"
    var add_os_type = "OS type"
    var add_name_your_device = "Name your device"
    var add_an_error_occured_while_trying_to_add_a_new_device_ = "An error occured while trying to add a new device. Please try again, if error persists contact Dynarisk"
    var add_please_select_required_fields = "Please select required fields"
    var add_please_check_if_device_type_and_os_type_is_set_and = "Please check if Device type and OS type is set and try again"
    var add_device_name = "Device Name"
    var add_optional = "optional"
    var data_activation_email_for_your_data_has_been_sent = "Activation email for your {{data}} has been sent"
    var data_check_your_email_for_your_activation_link_it_could = "Check your email for your activation link, it could have gone into your spam folder."
    var data_your_data_has_been_added_but_it_s_not_active_yet = "Your {{data}} has been added but it's not active yet"
    var data_registration_email_ = "Registration email"
    var data_family_member_s_email_ = "Family member's email"
    var data_ok_got_it = "Ok got it"
    var data_email_can_t_be_empty_please_try_again = "Email can't be empty. Please try again"
    var data_phone_can_t_be_empty_please_try_again = "Phone can't be empty. Please try again"
    var data_credit_card_can_t_be_empty_please_try_again = "Credit Card can't be empty. Please try again"
    var data_email = "email"
    var data_emails = "emails"
    var data_card = "card"
    var data_cards = "cards"
    var data_phone = "phone"
    var data_phones = "phones"
    var data_no_data = "No Data"
    var data_no_data_is_available_right_now_new_data_will_show_ = "No data is available right now. New data will show up here. You can insert it from the panel above"
    var settings_change_language = "Change Language"
    var settings_email_notification = "Email notification"
    var settings_are_you_sure_you_want_to_log_out_ = "Are you sure you want to Log Out?"
    var settings_type_your_current_password = "Type your current password"
    var settings_retype_new_password = "Retype new password"
    var settings_password_can_t_be_empty = "Password can't be empty"
    var settings_password_doesn_t_match = "Password doesn't match"
    var settings_password_too_short_add_number_chars_ = "Password too short. (Add {{number}} chars)"
    var settings_password_must_contain_lower_case_letters = "Password must contain lower case letters"
    var settings_password_must_contain_upper_case_letters = "Password must contain upper case letters"
    var settings_add_at_least_one_special_character = "Add at least one special character"
    var settings_add_at_least_one_digit = "Add at least one digit"
    var settings_use_at_least_8_characters_and_include_upper_and_lo = "Use at least 8 characters and include Upper and Lower case letters, numbers and special characters"
    var settings_ok = "OK"
    var settings_you_have_to_include_a_reason = "You have to include a reason"
    var settings_your_account_is_deleted_we_re_sorry_to_see_you_go = "Your account is deleted. We're sorry to see you go"
    var assessment_start = "Start"
    var assessment_almost_done = "Almost Done"
    var assessment_assessing_your_risk = "Assessing your risk"
    var assessment_you_must_select_at_least_one = "You must select at least one"
    var assessment_redirecting_to = "Redirecting to"
    var assessment_your_assessment_is_now_complete_we_will_generate_a = "Your assessment is now complete; we will generate a cyber security score based on the answers you provided. We added your device and email to protect them; you can start adding more devices and emails to get a higher security score."
    var assessment_all_done = "All Done"
    var to_set_a_reminder = "Set a reminder"
    var to_in_1_day = "In 1 day"
    var to_in_days_days = "In {{days}} days"
    var to_in_weeks_weeks = "In {{weeks}} weeks"
    var to_filter_tasks = "Filter Tasks"
    var to_reminder_set_for_1_week = "Reminder set for 1 week"
    var to_reminder_set_for_weeks_weeks = "Reminder set for {{weeks}} weeks"
    var to_reminder_set_for_1_day = "Reminder set for 1 day"
    var to_reminder_set_for_days_days = "Reminder set for {{days}} days"
    var to_due_in_days_days = "Due in {{days}} days"
    var to_due_in_1_day = "Due in 1 day"
    var to_reminder_set_for = "Reminder set for"
    var to_clear_filter = "Clear Filter"
    var to_you_have_no_tasks_in_your_to_do_list_check_once_in = "You have no tasks in your to do list. Check once in a while to make sure you're up to date with a tailored information in order to protect your devices and personal data"
    var to_accounts_exposed = "Accounts Exposed"
    var to_tap_here_to_see_your_raw_breached_data = "Tap here to see your RAW Breached data"
    var to_make_sure_you_are_in_a_private_place_the_data_you_ = "Make sure you are in a private place. The data you are about to see may contain your private sensitive information"
    var to_search_apps = "Search apps"
    var to_visit_website = "Visit website"
    var to_your_trial_has_started = "Your trial has Started"
    var scans_scans_have_finished_all_tasks_please_wait_as_you_w = "Scans have finished all tasks. Please wait as you will now proceed to the next step..."
    var scans_loading_assessment = "Loading Assessment"
    var support_finding_a_solution_by_your_own = "Finding a Solution by Your Own"
    var support_call_us_now = "Call us Now"
    var support_working_hours_8_00__13_00 = "Working hours 8:00 - 13:00"
    var support_working_hours_8_00__17_00 = "Working hours 8:00 - 13:00"
    var menu_data = "Data"
    var menu_support = "Support"
    var device_activating_device_name_ = "Activating {{device_name}}"
    var device_activating_device = "Activating Device"
    var device_done = "Done"
    var onboarding_what_s_your_email_ = "What's your email?"
    var onboarding_can_t_leave_email_empty = "Can't leave email empty"
    var onboarding_bad_email_format = "Bad email format"
    var onboarding_something_went_wrong_please_contact_cyberx_asap_ = "Something went wrong, please contact CyberX ASAP!"
    var name_what_s_your_name_ = "What's your name?"
    var name_can_t_be_less_than_3_characters = "Can't be less than 3 characters"
    var name_can_t_be_less_than_2_characters = "Can't be less than 2 characters"
    var name_can_t_use_special_characters = "Can't use special characters"
    var phone_what_s_your_phone_number_ = "What's your Phone number?"
    var password_choose_your_password = "Choose your password"
    var password_password_must_contain_lower_case_letters = "Password must contain lower case letters"
    var password_password_must_contain_upper_case_letters = "Password must contain upper case letters"
    var password_add_at_least_one_special_character = "Add at least one special character"
    var password_add_at_least_one_digit = "Add at least one digit"
    var terms_these_terms = "These terms"
    var terms_terms_conditions = "Terms & Conditions"
    var verify_verify_your_email = "Verify your email"
    var coupon_got_a_coupon_ = "Got a Coupon?"
    var edit_what_s_your_email_ = "What's your email?"
    var forgot_find_your_password = "Find your Password"
    var forgot_recover_password = "Recover Password"
    var forgot_our_support_is_always_there_in_case_you_need_help_ = "Our support is always there in case you need help with a task or you have any security concerns"
    var forgot_get_in_touch_with_our_team_of_cyber_security_exper = "Get in touch with our team of cyber security experts if you need a hand. We'll help you get safer online so you can use the Internet without worry."
    var forgot_add_coupon = "Add Coupon"
    var forgot_coupon_code = "Coupon Code"
    var forgot_message_sent_successfully_ = "Message Sent Successfully!"
    var forgot_our_customer_support_will_get_back_to_you_via_emai = "Our Customer Support will get back to you via email you've provided"
    var forgot_security_is_our_main_concern_this_message_is_priva = "Security is our main concern.This message is private and is sent encrypted, so don't hesitate to share sensitive information"
    var forgot_os_at_latest_version = "OS at latest version"
    var forgot_jail_break_check = "Jail break check"
    var forgot_screen_lock_enabled = "Screen lock enabled"
    var popup_coupon_plan_title = "Plan Selection"
    var popup_coupon_plan_subtitle  = "Your plan selection is now complete"
    var plan_detail_what_you_get = "what you get"
    var plan_billed_annually = "£{{price}} billed annually"
    var plan_month = "month"
    var vip = "vip"
    var deleting_email_error = "An error occurred while deleting an email"
    var deleting_phone_error = "An error occurred while deleting phone number"
    var no_plan_selected = "No plan selected. Please login to CyberXpert web choose one and then try again"
    var device_add_another_device = "Add Another Device"
    var device_go_to_do_list = "Go to To Do list"
    var we_recommend_header = "We Recommend"
    var email_us_fill_all_fields = "Please fill all fields before submitting"
    var scheduling_scam_emails = "Scheduling scam emails"
    var we_are_scheduling_some_fake_email_scams = "We're scheduling some fake email scams to send you over the coming weeks and months. See if you can spot them!"
    var dashboard_data_breach_popup_description_text_missing = "We scan your personal information  to check if your personal information has been breached or leaked."
    var dashboard_security_popup_description_text_missing = "We scan your applications, operating system and plugins to check for vulnerabilities that may leave you at risk of cyber attack."
    var dashboard_router_popup_description_text_missing = "We scan your router to make sure cyber criminals can't access it, or your home network."
    var dashboard_scam_emails_desc_text_missing = "Avoid falling victim to scams like phishing, ransom and push payment fraud by learning how to spot them."
    var dashboard_vulnerability_scans_popup_desc_missing =  "We scan your devices to see if they have vulnerabilities that would leave you open to hacking."
    var password_guidelines_with_tags = "Use at least {{highlight}}8 characters{{/highlight}} and include {{highlight}}Upper{{/highlight}} and {{highlight}}Lower case{{/highlight}} letters, {{highlight}}numbers{{/highlight}} and {{highlight}}special characters{{/highlight}} like!"
    var language_changed_header = "Language changed"
    var language_changed_subheader = "You will need to log in once again for changes to take place"
    var new_device_use_app_header =  "New device notice"
    var new_device_use_app_subheader = "Launch our app from device you wish to add and it will be added automatically"
    var navigate_to_login = "Navigate to login"
    var passed_plan = "Unfortunately, your automatic plan renewal failed. Please login again, select a plan and start a new subscription to continue using your account"
    var apple_id_has_plan_enabled = "This Apple ID is already linked to another account - {{email}}. Please try again to login using the linked account or with a different Apple ID."
    var restore_not_available = "This option to restore this subscription is not available at this time. Please contact support for further assistance"
    var plan_restored = "Your subscription is now successfully restored"
    var plan_will_renew_on_date = "Your subscription will be automatically renewed on {{date}} unless cancelled one day prior to renewal."
    var restore = "Restore"
    var terms_of_service = "Terms of Service"
    var buy_plan_explainer = "Subscriptions will be charged to your credit card through your iTunes account. Your subscription will automatically renew unless canceled at least 24 hours before the end of the current period. You will not be able to cancel the subscription once activated. Manage your subscriptions in Account Settings after purchase"
    var system_data_access = "System data access"
    var year = "year"
    var personal_data_scans_info = "We are scanning your {{data_type}}.\\r\\nIf we discover any vulnerabilities or breaches you will receive a new action in your To Do list. Actions will be added once the scan is complete."
    var router_for_vulnerabilities = "router for vulnerabilities"
    var device_for_vulnerabilities = "device for vulnerabilities"
    var email_address_for_breaches = "email address for breaches"
    var email_in_use = "This email is already in use"
    
    var plan_features : [String : Any] = [:]
    
    func getTranslationFor(slug: String) -> String {
        return Localization.shared.plan_features[slug] as? String ?? ""
    }

    func getCurrentLanguage(completion: @escaping (Bool) -> ()) {
        let langFile = UserData.shared.localUserData.languageFile ?? "en_GB.json"
        guard let url =  CyberExpertAPIEndpoint.localization_get_language_by(langFile).url() else { completion(false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: false, request: request) { (data, _, error) in
                        
            if let data = data, let json = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                                
                for (key, value) in (json ?? [:]) {
                    if key.contains("plan-feature") {
                        Localization.shared.plan_features[key] = value
                    }
                }
                                
                if let a = json?["login_enter_login_information"] as? String { Localization.shared.login_enter_login_information = a }
                if let a = json?["dashboard_tasks_to_finish_in_order_to_protect_yourself"] as? String { Localization.shared.dashboard_tasks_to_finish_in_order_to_protect_yourself = a }
                if let a = json?["login_errror_occured_while_saving_new_device_please_try_"] as? String { Localization.shared.login_errror_occured_while_saving_new_device_please_try_ = a }
                if let a = json?["login_password_field_is_empty_"] as? String { Localization.shared.login_password_field_is_empty_ = a }
                if let a = json?["login_email_address_field_is_empty_"] as? String { Localization.shared.login_email_address_field_is_empty_ = a }
                if let a = json?["data_check_your_email_for_your_activation_link_it_could"] as? String { Localization.shared.data_check_your_email_for_your_activation_link_it_could = a }
                if let a = json?["data_activation_email_for_your_data_has_been_sent"] as? String { Localization.shared.data_activation_email_for_your_data_has_been_sent = a }
                if let a = json?["add_optional"] as? String { Localization.shared.add_optional = a }
                if let a = json?["terms_of_service"] as? String { Localization.shared.terms_of_service = a }
                if let a = json?["buy_plan_explainer"] as? String { Localization.shared.buy_plan_explainer = a }
                if let a = json?["popup_coupon_plan_title"] as? String { Localization.shared.popup_coupon_plan_title = a }
                if let a = json?["popup_coupon_plan_subtitle"] as? String { Localization.shared.popup_coupon_plan_subtitle = a }
                if let a = json?["plan_detail_what_you_get"] as? String { Localization.shared.plan_detail_what_you_get = a }
                if let a = json?["plan_billed_annually"] as? String { Localization.shared.plan_billed_annually = a }
                if let a = json?["plan_month"] as? String { Localization.shared.plan_month = a }
                if let a = json?["vip"] as? String { Localization.shared.vip = a }
                if let a = json?["deleting_email_error"] as? String { Localization.shared.deleting_email_error = a }
                if let a = json?["deleting_phone_error"] as? String { Localization.shared.deleting_phone_error = a }
                if let a = json?["no_plan_selected"] as? String { Localization.shared.no_plan_selected = a }
                if let a = json?["device_add_another_device"] as? String { Localization.shared.device_add_another_device = a }
                if let a = json?["device_go_to_do_list"] as? String { Localization.shared.device_go_to_do_list = a }
                if let a = json?["we_recommend_header"] as? String { Localization.shared.we_recommend_header = a }
                if let a = json?["email_us_fill_all_fields"] as? String { Localization.shared.email_us_fill_all_fields = a }
                if let a = json?["password_guidelines_with_tags"] as? String { Localization.shared.password_guidelines_with_tags = a }
                if let a = json?["scheduling_scam_emails"] as? String { Localization.shared.scheduling_scam_emails = a }
                if let a = json?["we_are_scheduling_some_fake_email_scams"] as? String { Localization.shared.we_are_scheduling_some_fake_email_scams = a }
                if let a = json?["dashboard_data_breach_popup_description_text_missing"] as? String { Localization.shared.dashboard_data_breach_popup_description_text_missing = a }
                if let a = json?["dashboard_security_popup_description_text_missing"] as? String { Localization.shared.dashboard_security_popup_description_text_missing = a }
                if let a = json?["dashboard_router_popup_description_text_missing"] as? String { Localization.shared.dashboard_router_popup_description_text_missing = a }
                if let a = json?["dashboard_scam_emails_desc_text_missing"] as? String { Localization.shared.dashboard_scam_emails_desc_text_missing = a }
                if let a = json?["dashboard_vulnerability_scans_popup_desc_missing"] as? String { Localization.shared.dashboard_vulnerability_scans_popup_desc_missing = a }
                if let a = json?["too_long_max_16"] as? String { Localization.shared.too_long_max_16 = a }
                if let a = json?["too_short_min_2"] as? String { Localization.shared.too_short_min_2 = a }
                if let a = json?["finish_signup"] as? String { Localization.shared.finish_signup = a }
                if let a = json?["finish_upgrade"] as? String { Localization.shared.finish_upgrade = a }
                if let a = json?["subject"] as? String { Localization.shared.subject = a }
                if let a = json?["activation_link_is_sent"] as? String { Localization.shared.activation_link_is_sent = a }
                if let a = json?["new_device"] as? String { Localization.shared.new_device = a }
                if let a = json?["logout_x_sec"] as? String { Localization.shared.logout_x_sec = a }
                if let a = json?["everything_ok"] as? String { Localization.shared.everything_ok = a }
                if let a = json?["terms_6_1_b"] as? String { Localization.shared.terms_6_1_b = a }
                if let a = json?["page_x_of_count"] as? String { Localization.shared.page_x_of_count = a }
                if let a = json?["browser_version"] as? String { Localization.shared.browser_version = a }
                if let a = json?["your_subscription"] as? String { Localization.shared.your_subscription = a }
                if let a = json?["os_support_error"] as? String { Localization.shared.os_support_error = a }
                if let a = json?["subject_max_char"] as? String { Localization.shared.subject_max_char = a }
                if let a = json?["message_max_char"] as? String { Localization.shared.message_max_char = a }
                if let a = json?["outdated"] as? String { Localization.shared.outdated = a }
                if let a = json?["need_to_reassess"] as? String { Localization.shared.need_to_reassess = a }
                if let a = json?["message_is_sent"] as? String { Localization.shared.message_is_sent = a }
                if let a = json?["scanning_browser"] as? String { Localization.shared.scanning_browser = a }
                if let a = json?["scanning_os"] as? String { Localization.shared.scanning_os = a }
                if let a = json?["found"] as? String { Localization.shared.found = a }
                if let a = json?["device_add_success"] as? String { Localization.shared.device_add_success = a }
                if let a = json?["invalid_credentials"] as? String { Localization.shared.invalid_credentials = a }
                if let a = json?["unknown"] as? String { Localization.shared.unknown = a }
                if let a = json?["select"] as? String { Localization.shared.select = a }
                if let a = json?["coming_soon"] as? String { Localization.shared.coming_soon = a }
                if let a = json?["raw_data_exposed"] as? String { Localization.shared.raw_data_exposed = a }
                if let a = json?["your_plan"] as? String { Localization.shared.your_plan = a }
                if let a = json?["family_member"] as? String { Localization.shared.family_member = a }
                if let a = json?["non_family_member"] as? String { Localization.shared.non_family_member = a }
                if let a = json?["plan_status_processing"] as? String { Localization.shared.plan_status_processing = a }
                if let a = json?["one_minute_left_to_auto_logout"] as? String { Localization.shared.one_minute_left_to_auto_logout = a }
                if let a = json?["browser_product"] as? String { Localization.shared.browser_product = a }
                if let a = json?["browser_vendor"] as? String { Localization.shared.browser_vendor = a }
                if let a = json?["build_version_number"] as? String { Localization.shared.build_version_number = a }
                if let a = json?["operation_system"] as? String { Localization.shared.operation_system = a }
                if let a = json?["i_dont_know"] as? String { Localization.shared.i_dont_know = a }
                if let a = json?["confirm"] as? String { Localization.shared.confirm = a }
                if let a = json?["provided_data"] as? String { Localization.shared.provided_data = a }
                if let a = json?["or"] as? String { Localization.shared.or = a }
                if let a = json?["this_link"] as? String { Localization.shared.this_link = a }
                if let a = json?["good_luck"] as? String { Localization.shared.good_luck = a }
                if let a = json?["please_try"] as? String { Localization.shared.please_try = a }
                if let a = json?["page_might_have_been_removed"] as? String { Localization.shared.page_might_have_been_removed = a }
                if let a = json?["error"] as? String { Localization.shared.error = a }
                if let a = json?["tp_12_2"] as? String { Localization.shared.tp_12_2 = a }
                if let a = json?["tp_12_1"] as? String { Localization.shared.tp_12_1 = a }
                if let a = json?["tp_12_strong"] as? String { Localization.shared.tp_12_strong = a }
                if let a = json?["tp_11"] as? String { Localization.shared.tp_11 = a }
                if let a = json?["tp_11_strong"] as? String { Localization.shared.tp_11_strong = a }
                if let a = json?["tp_10"] as? String { Localization.shared.tp_10 = a }
                if let a = json?["tp_10_strong"] as? String { Localization.shared.tp_10_strong = a }
                if let a = json?["tp_9"] as? String { Localization.shared.tp_9 = a }
                if let a = json?["tp_8"] as? String { Localization.shared.tp_8 = a }
                if let a = json?["tp_8_strong"] as? String { Localization.shared.tp_8_strong = a }
                if let a = json?["tp_7"] as? String { Localization.shared.tp_7 = a }
                if let a = json?["tp_7_strong"] as? String { Localization.shared.tp_7_strong = a }
                if let a = json?["tp_6"] as? String { Localization.shared.tp_6 = a }
                if let a = json?["tp_6_strong"] as? String { Localization.shared.tp_6_strong = a }
                if let a = json?["tp_5_3"] as? String { Localization.shared.tp_5_3 = a }
                if let a = json?["tp_5_2"] as? String { Localization.shared.tp_5_2 = a }
                if let a = json?["tp_5_1"] as? String { Localization.shared.tp_5_1 = a }
                if let a = json?["tp_5"] as? String { Localization.shared.tp_5 = a }
                if let a = json?["tp_5_strong"] as? String { Localization.shared.tp_5_strong = a }
                if let a = json?["tp_4_5"] as? String { Localization.shared.tp_4_5 = a }
                if let a = json?["tp_4_5_strong"] as? String { Localization.shared.tp_4_5_strong = a }
                if let a = json?["tp_4_4"] as? String { Localization.shared.tp_4_4 = a }
                if let a = json?["tp_4_4_strong"] as? String { Localization.shared.tp_4_4_strong = a }
                if let a = json?["tp_4_3"] as? String { Localization.shared.tp_4_3 = a }
                if let a = json?["tp_4_3_strong"] as? String { Localization.shared.tp_4_3_strong = a }
                if let a = json?["tp_4_2"] as? String { Localization.shared.tp_4_2 = a }
                if let a = json?["tp_4_2_strong"] as? String { Localization.shared.tp_4_2_strong = a }
                if let a = json?["tp_4_1_outro"] as? String { Localization.shared.tp_4_1_outro = a }
                if let a = json?["tp_4_1_d"] as? String { Localization.shared.tp_4_1_d = a }
                if let a = json?["tp_2_4"] as? String { Localization.shared.tp_2_4 = a }
                if let a = json?["tp_2_3"] as? String { Localization.shared.tp_2_3 = a }
                if let a = json?["tp_2_2"] as? String { Localization.shared.tp_2_2 = a }
                if let a = json?["tp_2_1"] as? String { Localization.shared.tp_2_1 = a }
                if let a = json?["tp_2"] as? String { Localization.shared.tp_2 = a }
                if let a = json?["tp_2_strong"] as? String { Localization.shared.tp_2_strong = a }
                if let a = json?["tp_1"] as? String { Localization.shared.tp_1 = a }
                if let a = json?["tp_1_strong"] as? String { Localization.shared.tp_1_strong = a }
                if let a = json?["tp_intro"] as? String { Localization.shared.tp_intro = a }
                if let a = json?["tp_last_revision"] as? String { Localization.shared.tp_last_revision = a }
                if let a = json?["terms_of_service_and_privacy_policy"] as? String { Localization.shared.terms_of_service_and_privacy_policy = a }
                if let a = json?["privacy_and_cookie_policy"] as? String { Localization.shared.privacy_and_cookie_policy = a }
                if let a = json?["server_error"] as? String { Localization.shared.server_error = a }
                if let a = json?["wrong_password"] as? String { Localization.shared.wrong_password = a }
                if let a = json?["permanently_delete_an_account"] as? String { Localization.shared.permanently_delete_an_account = a }
                if let a = json?["exit_cyber_risk_assessment"] as? String { Localization.shared.exit_cyber_risk_assessment = a }
                if let a = json?["view_more"] as? String { Localization.shared.view_more = a }
                if let a = json?["view_less"] as? String { Localization.shared.view_less = a }
                if let a = json?["terms_and_conditions"] as? String { Localization.shared.terms_and_conditions = a }
                if let a = json?["accept_and_continue"] as? String { Localization.shared.accept_and_continue = a }
                if let a = json?["decline"] as? String { Localization.shared.decline = a }
                if let a = json?["terms_14_6"] as? String { Localization.shared.terms_14_6 = a }
                if let a = json?["terms_14_6_strong"] as? String { Localization.shared.terms_14_6_strong = a }
                if let a = json?["terms_14_5"] as? String { Localization.shared.terms_14_5 = a }
                if let a = json?["terms_14_5_strong"] as? String { Localization.shared.terms_14_5_strong = a }
                if let a = json?["terms_14_4"] as? String { Localization.shared.terms_14_4 = a }
                if let a = json?["terms_14_4_strong"] as? String { Localization.shared.terms_14_4_strong = a }
                if let a = json?["terms_14_3"] as? String { Localization.shared.terms_14_3 = a }
                if let a = json?["terms_14_3_strong"] as? String { Localization.shared.terms_14_3_strong = a }
                if let a = json?["terms_14_2"] as? String { Localization.shared.terms_14_2 = a }
                if let a = json?["terms_14_2_strong"] as? String { Localization.shared.terms_14_2_strong = a }
                if let a = json?["terms_14_1"] as? String { Localization.shared.terms_14_1 = a }
                if let a = json?["terms_14_1_strong"] as? String { Localization.shared.terms_14_1_strong = a }
                if let a = json?["terms_14_strong"] as? String { Localization.shared.terms_14_strong = a }
                if let a = json?["terms_13"] as? String { Localization.shared.terms_13 = a }
                if let a = json?["terms_13_strong"] as? String { Localization.shared.terms_13_strong = a }
                if let a = json?["terms_12_3"] as? String { Localization.shared.terms_12_3 = a }
                if let a = json?["terms_12_3_strong"] as? String { Localization.shared.terms_12_3_strong = a }
                if let a = json?["terms_12_2_strong_1"] as? String { Localization.shared.terms_12_2_strong_1 = a }
                if let a = json?["terms_12_2"] as? String { Localization.shared.terms_12_2 = a }
                if let a = json?["terms_12_2_strong"] as? String { Localization.shared.terms_12_2_strong = a }
                if let a = json?["terms_12_1"] as? String { Localization.shared.terms_12_1 = a }
                if let a = json?["terms_12_1_strong"] as? String { Localization.shared.terms_12_1_strong = a }
                if let a = json?["terms_12_strong"] as? String { Localization.shared.terms_12_strong = a }
                if let a = json?["terms_11_5"] as? String { Localization.shared.terms_11_5 = a }
                if let a = json?["terms_11_5_strong"] as? String { Localization.shared.terms_11_5_strong = a }
                if let a = json?["terms_11_4"] as? String { Localization.shared.terms_11_4 = a }
                if let a = json?["terms_11_4_strong"] as? String { Localization.shared.terms_11_4_strong = a }
                if let a = json?["terms_11_3"] as? String { Localization.shared.terms_11_3 = a }
                if let a = json?["terms_11_3_strong"] as? String { Localization.shared.terms_11_3_strong = a }
                if let a = json?["terms_11_2"] as? String { Localization.shared.terms_11_2 = a }
                if let a = json?["terms_11_1"] as? String { Localization.shared.terms_11_1 = a }
                if let a = json?["terms_11_1_strong"] as? String { Localization.shared.terms_11_1_strong = a }
                if let a = json?["terms_11_strong"] as? String { Localization.shared.terms_11_strong = a }
                if let a = json?["terms_rights_2"] as? String { Localization.shared.terms_rights_2 = a }
                if let a = json?["terms_rights_c"] as? String { Localization.shared.terms_rights_c = a }
                if let a = json?["terms_rights_b"] as? String { Localization.shared.terms_rights_b = a }
                if let a = json?["terms_rights_a"] as? String { Localization.shared.terms_rights_a = a }
                if let a = json?["services"] as? String { Localization.shared.services = a }
                if let a = json?["terms_rights_1_2"] as? String { Localization.shared.terms_rights_1_2 = a }
                if let a = json?["terms_rights_1_1"] as? String { Localization.shared.terms_rights_1_1 = a }
                if let a = json?["terms_rights_1"] as? String { Localization.shared.terms_rights_1 = a }
                if let a = json?["terms_rights"] as? String { Localization.shared.terms_rights = a }
                if let a = json?["terms_10_2"] as? String { Localization.shared.terms_10_2 = a }
                if let a = json?["terms_10_2_strong"] as? String { Localization.shared.terms_10_2_strong = a }
                if let a = json?["terms_10_1"] as? String { Localization.shared.terms_10_1 = a }
                if let a = json?["terms_10_1_strong"] as? String { Localization.shared.terms_10_1_strong = a }
                if let a = json?["terms_10"] as? String { Localization.shared.terms_10 = a }
                if let a = json?["terms_9_1"] as? String { Localization.shared.terms_9_1 = a }
                if let a = json?["terms_9_strong_1"] as? String { Localization.shared.terms_9_strong_1 = a }
                if let a = json?["terms_9_strong"] as? String { Localization.shared.terms_9_strong = a }
                if let a = json?["terms_8_4"] as? String { Localization.shared.terms_8_4 = a }
                if let a = json?["terms_8_4_strong"] as? String { Localization.shared.terms_8_4_strong = a }
                if let a = json?["terms_8_3_c"] as? String { Localization.shared.terms_8_3_c = a }
                if let a = json?["terms_8_3_b"] as? String { Localization.shared.terms_8_3_b = a }
                if let a = json?["terms_8_3_a"] as? String { Localization.shared.terms_8_3_a = a }
                if let a = json?["terms_8_3"] as? String { Localization.shared.terms_8_3 = a }
                if let a = json?["terms_8_3_strong"] as? String { Localization.shared.terms_8_3_strong = a }
                if let a = json?["terms_8_2_1"] as? String { Localization.shared.terms_8_2_1 = a }
                if let a = json?["terms_8_2"] as? String { Localization.shared.terms_8_2 = a }
                if let a = json?["terms_8_2_strong"] as? String { Localization.shared.terms_8_2_strong = a }
                if let a = json?["terms_8_1"] as? String { Localization.shared.terms_8_1 = a }
                if let a = json?["terms_8"] as? String { Localization.shared.terms_8 = a }
                if let a = json?["terms_8_strong_1"] as? String { Localization.shared.terms_8_strong_1 = a }
                if let a = json?["terms_8_strong"] as? String { Localization.shared.terms_8_strong = a }
                if let a = json?["terms_7_4"] as? String { Localization.shared.terms_7_4 = a }
                if let a = json?["terms_7_4_strong"] as? String { Localization.shared.terms_7_4_strong = a }
                if let a = json?["terms_7_3_a"] as? String { Localization.shared.terms_7_3_a = a }
                if let a = json?["terms_7_3"] as? String { Localization.shared.terms_7_3 = a }
                if let a = json?["terms_7_3_strong"] as? String { Localization.shared.terms_7_3_strong = a }
                if let a = json?["terms_7_2"] as? String { Localization.shared.terms_7_2 = a }
                if let a = json?["terms_7_2_strong"] as? String { Localization.shared.terms_7_2_strong = a }
                if let a = json?["terms_7_1_a"] as? String { Localization.shared.terms_7_1_a = a }
                if let a = json?["terms_7_1_a_strong"] as? String { Localization.shared.terms_7_1_a_strong = a }
                if let a = json?["terms_7_1"] as? String { Localization.shared.terms_7_1 = a }
                if let a = json?["terms_7_1_strong"] as? String { Localization.shared.terms_7_1_strong = a }
                if let a = json?["terms_7_strong"] as? String { Localization.shared.terms_7_strong = a }
                if let a = json?["terms_6_5_a"] as? String { Localization.shared.terms_6_5_a = a }
                if let a = json?["terms_6_5_a_strong"] as? String { Localization.shared.terms_6_5_a_strong = a }
                if let a = json?["terms_6_5"] as? String { Localization.shared.terms_6_5 = a }
                if let a = json?["terms_6_5_strong"] as? String { Localization.shared.terms_6_5_strong = a }
                if let a = json?["terms_6_4_a"] as? String { Localization.shared.terms_6_4_a = a }
                if let a = json?["terms_6_4"] as? String { Localization.shared.terms_6_4 = a }
                if let a = json?["terms_6_4_strong"] as? String { Localization.shared.terms_6_4_strong = a }
                if let a = json?["terms_6_3"] as? String { Localization.shared.terms_6_3 = a }
                if let a = json?["terms_6_3_strong"] as? String { Localization.shared.terms_6_3_strong = a }
                if let a = json?["terms_6_2_e"] as? String { Localization.shared.terms_6_2_e = a }
                if let a = json?["terms_6_2_d"] as? String { Localization.shared.terms_6_2_d = a }
                if let a = json?["terms_6_2_c"] as? String { Localization.shared.terms_6_2_c = a }
                if let a = json?["terms_6_2_b"] as? String { Localization.shared.terms_6_2_b = a }
                if let a = json?["terms_6_2_a"] as? String { Localization.shared.terms_6_2_a = a }
                if let a = json?["terms_6_2"] as? String { Localization.shared.terms_6_2 = a }
                if let a = json?["terms_6_2_strong"] as? String { Localization.shared.terms_6_2_strong = a }
                if let a = json?["terms_6_1_c"] as? String { Localization.shared.terms_6_1_c = a }
                if let a = json?["terms_6_1_c_strong"] as? String { Localization.shared.terms_6_1_c_strong = a }
                if let a = json?["terms_6_1_b_strong"] as? String { Localization.shared.terms_6_1_b_strong = a }
                if let a = json?["terms_6_1_a_1"] as? String { Localization.shared.terms_6_1_a_1 = a }
                if let a = json?["terms_6_1_a_strong_1"] as? String { Localization.shared.terms_6_1_a_strong_1 = a }
                if let a = json?["terms_6_1_a"] as? String { Localization.shared.terms_6_1_a = a }
                if let a = json?["terms_6_1_a_strong"] as? String { Localization.shared.terms_6_1_a_strong = a }
                if let a = json?["terms_6_1"] as? String { Localization.shared.terms_6_1 = a }
                if let a = json?["terms_6_1_strong"] as? String { Localization.shared.terms_6_1_strong = a }
                if let a = json?["terms_6_strong"] as? String { Localization.shared.terms_6_strong = a }
                if let a = json?["terms_5_additional"] as? String { Localization.shared.terms_5_additional = a }
                if let a = json?["terms_5_1_b"] as? String { Localization.shared.terms_5_1_b = a }
                if let a = json?["terms_5_1_a"] as? String { Localization.shared.terms_5_1_a = a }
                if let a = json?["terms_5_1"] as? String { Localization.shared.terms_5_1 = a }
                if let a = json?["terms_5_1_strong"] as? String { Localization.shared.terms_5_1_strong = a }
                if let a = json?["terms_5_strong"] as? String { Localization.shared.terms_5_strong = a }
                if let a = json?["terms_4_1"] as? String { Localization.shared.terms_4_1 = a }
                if let a = json?["terms_3_3_7"] as? String { Localization.shared.terms_3_3_7 = a }
                if let a = json?["terms_3_3_6"] as? String { Localization.shared.terms_3_3_6 = a }
                if let a = json?["terms_3_3_5"] as? String { Localization.shared.terms_3_3_5 = a }
                if let a = json?["terms_3_3_4"] as? String { Localization.shared.terms_3_3_4 = a }
                if let a = json?["terms_3_3_3"] as? String { Localization.shared.terms_3_3_3 = a }
                if let a = json?["terms_3_3_2"] as? String { Localization.shared.terms_3_3_2 = a }
                if let a = json?["terms_3_3_1"] as? String { Localization.shared.terms_3_3_1 = a }
                if let a = json?["terms_3_3"] as? String { Localization.shared.terms_3_3 = a }
                if let a = json?["terms_3_3_strong"] as? String { Localization.shared.terms_3_3_strong = a }
                if let a = json?["terms_3_2"] as? String { Localization.shared.terms_3_2 = a }
                if let a = json?["terms_3_2_strong"] as? String { Localization.shared.terms_3_2_strong = a }
                if let a = json?["terms_3_1_service_strong"] as? String { Localization.shared.terms_3_1_service_strong = a }
                if let a = json?["terms_3_1_strong"] as? String { Localization.shared.terms_3_1_strong = a }
                if let a = json?["terms_3_strong"] as? String { Localization.shared.terms_3_strong = a }
                if let a = json?["terms_2_4"] as? String { Localization.shared.terms_2_4 = a }
                if let a = json?["terms_2_4_strong"] as? String { Localization.shared.terms_2_4_strong = a }
                if let a = json?["terms_2_3"] as? String { Localization.shared.terms_2_3 = a }
                if let a = json?["terms_2_3_strong"] as? String { Localization.shared.terms_2_3_strong = a }
                if let a = json?["terms_2_2"] as? String { Localization.shared.terms_2_2 = a }
                if let a = json?["terms_2_2_strong"] as? String { Localization.shared.terms_2_2_strong = a }
                if let a = json?["terms_2_1"] as? String { Localization.shared.terms_2_1 = a }
                if let a = json?["terms_2_1_strong"] as? String { Localization.shared.terms_2_1_strong = a }
                if let a = json?["terms_2_strong"] as? String { Localization.shared.terms_2_strong = a }
                if let a = json?["terms_1_3_strong"] as? String { Localization.shared.terms_1_3_strong = a }
                if let a = json?["terms_1_2"] as? String { Localization.shared.terms_1_2 = a }
                if let a = json?["terms_1_2_strong"] as? String { Localization.shared.terms_1_2_strong = a }
                if let a = json?["terms_1_1"] as? String { Localization.shared.terms_1_1 = a }
                if let a = json?["terms_1_1_strong"] as? String { Localization.shared.terms_1_1_strong = a }
                if let a = json?["terms_1_strong"] as? String { Localization.shared.terms_1_strong = a }
                if let a = json?["you_have_been_automaticly_logout"] as? String { Localization.shared.you_have_been_automaticly_logout = a }
                if let a = json?["invalid_credit_card_number"] as? String { Localization.shared.invalid_credit_card_number = a }
                if let a = json?["plan_feature_support_type_premium"] as? String { Localization.shared.plan_feature_support_type_premium = a }
                if let a = json?["plan_feature_support_type_enhanced"] as? String { Localization.shared.plan_feature_support_type_enhanced = a }
                if let a = json?["plan_feature_support_type_standard"] as? String { Localization.shared.plan_feature_support_type_standard = a }
                if let a = json?["plan_status_success"] as? String { Localization.shared.plan_status_success = a }
                if let a = json?["plan_feature_description_vulnerability_scan"] as? String { Localization.shared.plan_feature_description_vulnerability_scan = a }
                if let a = json?["plan_feature_description_virus_removal"] as? String { Localization.shared.plan_feature_description_virus_removal = a }
                if let a = json?["plan_feature_description_cyber_restorations_services"] as? String { Localization.shared.plan_feature_description_cyber_restorations_services = a }
                if let a = json?["plan_feature_description_router_scan"] as? String { Localization.shared.plan_feature_description_router_scan = a }
                if let a = json?["plan_feature_description_phishing_simulator"] as? String { Localization.shared.plan_feature_description_phishing_simulator = a }
                if let a = json?["plan_feature_description_threats_alerts"] as? String { Localization.shared.plan_feature_description_threats_alerts = a }
                if let a = json?["plan_feature_description_support_type"] as? String { Localization.shared.plan_feature_description_support_type = a }
                if let a = json?["plan_feature_description_max_devices"] as? String { Localization.shared.plan_feature_description_max_devices = a }
                if let a = json?["plan_feature_description_max_family_and_friends"] as? String { Localization.shared.plan_feature_description_max_family_and_friends = a }
                if let a = json?["plan_feature_description_family_and_friends"] as? String { Localization.shared.plan_feature_description_family_and_friends = a }
                if let a = json?["plan_feature_description_max_user_emails"] as? String { Localization.shared.plan_feature_description_max_user_emails = a }
                if let a = json?["plan_feature_description_personalised_improvement_plan"] as? String { Localization.shared.plan_feature_description_personalised_improvement_plan = a }
                if let a = json?["plan_feature_description_cyber_security_score_and_report"] as? String { Localization.shared.plan_feature_description_cyber_security_score_and_report = a }
                if let a = json?["assessment_footer"] as? String { Localization.shared.assessment_footer = a }
                if let a = json?["plan_ultimate_description"] as? String { Localization.shared.plan_ultimate_description = a }
                if let a = json?["plan_advantage_description"] as? String { Localization.shared.plan_advantage_description = a }
                if let a = json?["plan_standard_description"] as? String { Localization.shared.plan_standard_description = a }
                if let a = json?["protected_data.verify_your_protected_data"] as? String { Localization.shared.protected_data_verify_your_protected_data = a }
                if let a = json?["protected_data.verifying"] as? String { Localization.shared.protected_data_verifying = a }
                if let a = json?["protected_data.phone_is_now_activated"] as? String { Localization.shared.protected_data_phone_is_now_activated = a }
                if let a = json?["protected_data.phone_activation_error"] as? String { Localization.shared.protected_data_phone_activation_error = a }
                if let a = json?["protected_data.email_is_now_activated"] as? String { Localization.shared.protected_data_email_is_now_activated = a }
                if let a = json?["protected_data.email_activation_error"] as? String { Localization.shared.protected_data_email_activation_error = a }
                if let a = json?["is_family_member"] as? String { Localization.shared.is_family_member = a }
                if let a = json?["i_have_completed_this_action"] as? String { Localization.shared.i_have_completed_this_action = a }
                if let a = json?["mark"] as? String { Localization.shared.mark = a }
                if let a = json?["first_show_action_reminder"] as? String { Localization.shared.first_show_action_reminder = a }
                if let a = json?["device.activate"] as? String { Localization.shared.device_activate = a }
                if let a = json?["device.device_activated"] as? String { Localization.shared.device_device_activated = a }
                if let a = json?["device.sure_delete_device"] as? String { Localization.shared.device_sure_delete_device = a }
                if let a = json?["device.delete_device"] as? String { Localization.shared.device_delete_device = a }
                if let a = json?["device.delete_warning"] as? String { Localization.shared.device_delete_warning = a }
                if let a = json?["device.add_device"] as? String { Localization.shared.device_add_device = a }
                if let a = json?["device.add_device_name"] as? String { Localization.shared.device_add_device_name = a }
                if let a = json?["devices_list.activate_device"] as? String { Localization.shared.devices_list_activate_device = a }
                if let a = json?["device.choose_operating_system"] as? String { Localization.shared.device_choose_operating_system = a }
                if let a = json?["device.add_new_device"] as? String { Localization.shared.device_add_new_device = a }
                if let a = json?["emails_delete.delete_email"] as? String { Localization.shared.emails_delete_delete_email = a }
                if let a = json?["to_do.task_error_loading"] as? String { Localization.shared.to_do_task_error_loading = a }
                if let a = json?["sidebar.download_app_reassignment"] as? String { Localization.shared.sidebar_download_app_reassignment = a }
                if let a = json?["sidebar.download_app"] as? String { Localization.shared.sidebar_download_app = a }
                if let a = json?["sidebar.manage_data"] as? String { Localization.shared.sidebar_manage_data = a }
                if let a = json?["monitored_data.phone_numbers"] as? String { Localization.shared.monitored_data_phone_numbers = a }
                if let a = json?["monitored_data.credit_cards"] as? String { Localization.shared.monitored_data_credit_cards = a }
                if let a = json?["i_need_help_completing_an_action_descr"] as? String { Localization.shared.i_need_help_completing_an_action_descr = a }
                if let a = json?["i_need_help_completing_an_action"] as? String { Localization.shared.i_need_help_completing_an_action = a }
                if let a = json?["i_have_a_billing_issue_descr"] as? String { Localization.shared.i_have_a_billing_issue_descr = a }
                if let a = json?["i_have_a_billing_issue"] as? String { Localization.shared.i_have_a_billing_issue = a }
                if let a = json?["i_have_a_problem_with_my_account_descr"] as? String { Localization.shared.i_have_a_problem_with_my_account_descr = a }
                if let a = json?["i_have_a_problem_with_my_account"] as? String { Localization.shared.i_have_a_problem_with_my_account = a }
                if let a = json?["i_think_i_ve_been_hacked_descr"] as? String { Localization.shared.i_think_i_ve_been_hacked_descr = a }
                if let a = json?["i_think_i_ve_been_hacked"] as? String { Localization.shared.i_think_i_ve_been_hacked = a }
                if let a = json?["plan_status_error"] as? String { Localization.shared.plan_status_error = a }
                if let a = json?["working_hours"] as? String { Localization.shared.working_hours = a }
                if let a = json?["replies_in_24"] as? String { Localization.shared.replies_in_24 = a }
                if let a = json?["email_us"] as? String { Localization.shared.email_us = a }
                if let a = json?["1_year"] as? String { Localization.shared.one_year = a }
                if let a = json?["vip_plan"] as? String { Localization.shared.vip_plan = a }
                if let a = json?["ultimate"] as? String { Localization.shared.ultimate = a }
                if let a = json?["advantage"] as? String { Localization.shared.advantage = a }
                if let a = json?["standard"] as? String { Localization.shared.standard = a }
                if let a = json?["plan"] as? String { Localization.shared.plan = a }
                if let a = json?["special_characters"] as? String { Localization.shared.special_characters = a }
                if let a = json?["numbers"] as? String { Localization.shared.numbers = a }
                if let a = json?["lowercase"] as? String { Localization.shared.lowercase = a }
                if let a = json?["uppercase"] as? String { Localization.shared.uppercase = a }
                if let a = json?["x_characters"] as? String { Localization.shared.x_characters = a }
                if let a = json?["billing"] as? String { Localization.shared.billing = a }
                if let a = json?["email_settings"] as? String { Localization.shared.email_settings = a }
                if let a = json?["plans"] as? String { Localization.shared.plans = a }
                if let a = json?["profile"] as? String { Localization.shared.profile = a }
                if let a = json?["find_a_solution"] as? String { Localization.shared.find_a_solution = a }
                if let a = json?["faq"] as? String { Localization.shared.faq = a }
                if let a = json?["card_must_contains"] as? String { Localization.shared.card_must_contains = a }
                if let a = json?["phone_must_contains"] as? String { Localization.shared.phone_must_contains = a }
                if let a = json?["can_t_get_tasks"] as? String { Localization.shared.can_t_get_tasks = a }
                if let a = json?["can_t_change_email"] as? String { Localization.shared.can_t_change_email = a }
                if let a = json?["email_cahnged"] as? String { Localization.shared.email_cahnged = a }
                if let a = json?["profile_deleted"] as? String { Localization.shared.profile_deleted = a }
                if let a = json?["can_t_delete_profile"] as? String { Localization.shared.can_t_delete_profile = a }
                if let a = json?["can_t_delete_account"] as? String { Localization.shared.can_t_delete_account = a }
                if let a = json?["can_t_save_answer"] as? String { Localization.shared.can_t_save_answer = a }
                if let a = json?["assessment reset_error"] as? String { Localization.shared.assessment_reset_error = a }
                if let a = json?["assessment_reseted"] as? String { Localization.shared.assessment_reseted = a }
                if let a = json?["device_assessment_subheader"] as? String { Localization.shared.device_assessment_subheader = a }
                if let a = json?["device_assessment"] as? String { Localization.shared.device_assessment = a }
                if let a = json?["complete_device_assessment"] as? String { Localization.shared.complete_device_assessment = a }
                if let a = json?["an_error_occured"] as? String { Localization.shared.an_error_occured = a }
                if let a = json?["password_strength_error"] as? String { Localization.shared.password_strength_error = a }
                if let a = json?["password_repeat_error"] as? String { Localization.shared.password_repeat_error = a }
                if let a = json?["password_change_error"] as? String { Localization.shared.password_change_error = a }
                if let a = json?["password_changed"] as? String { Localization.shared.password_changed = a }
                if let a = json?["can_t_show_payment_history"] as? String { Localization.shared.can_t_show_payment_history = a }
                if let a = json?["required"] as? String { Localization.shared.required = a }
                if let a = json?["device_activation_error"] as? String { Localization.shared.device_activation_error = a }
                if let a = json?["device_is_now_activated"] as? String { Localization.shared.device_is_now_activated = a }
                if let a = json?["get_phones_error"] as? String { Localization.shared.get_phones_error = a }
                if let a = json?["add_phone_error"] as? String { Localization.shared.add_phone_error = a }
                if let a = json?["phone_added"] as? String { Localization.shared.phone_added = a }
                if let a = json?["email_delete_error"] as? String { Localization.shared.email_delete_error = a }
                if let a = json?["email_deleted"] as? String { Localization.shared.email_deleted = a }
                if let a = json?["get_emails_error"] as? String { Localization.shared.get_emails_error = a }
                if let a = json?["add_email_error"] as? String { Localization.shared.add_email_error = a }
                if let a = json?["email_is_added"] as? String { Localization.shared.email_is_added = a }
                if let a = json?["field_is_required"] as? String { Localization.shared.field_is_required = a }
                if let a = json?["can_t_select_features"] as? String { Localization.shared.can_t_select_features = a }
                if let a = json?["coupon_not_applied"] as? String { Localization.shared.coupon_not_applied = a }
                if let a = json?["coupon_is_applied"] as? String { Localization.shared.coupon_is_applied = a }
                if let a = json?["activation_link_error"] as? String { Localization.shared.activation_link_error = a }
                if let a = json?["delete_credit_card_error"] as? String { Localization.shared.delete_credit_card_error = a }
                if let a = json?["phone_number_is_deleted"] as? String { Localization.shared.phone_number_is_deleted = a }
                if let a = json?["credit_card_is_deleted"] as? String { Localization.shared.credit_card_is_deleted = a }
                if let a = json?["get_credit_cards_error"] as? String { Localization.shared.get_credit_cards_error = a }
                if let a = json?["add_credit_card_error"] as? String { Localization.shared.add_credit_card_error = a }
                if let a = json?["credit_card_is_added"] as? String { Localization.shared.credit_card_is_added = a }
                if let a = json?["can_t_get_plans"] as? String { Localization.shared.can_t_get_plans = a }
                if let a = json?["device_delete_error"] as? String { Localization.shared.device_delete_error = a }
                if let a = json?["device_was_deleted"] as? String { Localization.shared.device_was_deleted = a }
                if let a = json?["can_t_fetch_devices"] as? String { Localization.shared.can_t_fetch_devices = a }
                if let a = json?["can_t_add_device"] as? String { Localization.shared.can_t_add_device = a }
                if let a = json?["deleting_credit_card_error"] as? String { Localization.shared.deleting_credit_card_error = a }
                if let a = json?["verification_is_resent"] as? String { Localization.shared.verification_is_resent = a }
                if let a = json?["can_t_resend_email"] as? String { Localization.shared.can_t_resend_email = a }
                if let a = json?["can_t_select_plan"] as? String { Localization.shared.can_t_select_plan = a }
                if let a = json?["can_t_change_personal_info"] as? String { Localization.shared.can_t_change_personal_info = a }
                if let a = json?["personal_info_changed"] as? String { Localization.shared.personal_info_changed = a }
                if let a = json?["cvv_is_required"] as? String { Localization.shared.cvv_is_required = a }
                if let a = json?["enter_valid_cvv"] as? String { Localization.shared.enter_valid_cvv = a }
                if let a = json?["year_is_required"] as? String { Localization.shared.year_is_required = a }
                if let a = json?["enter_valid_year"] as? String { Localization.shared.enter_valid_year = a }
                if let a = json?["month_is_required"] as? String { Localization.shared.month_is_required = a }
                if let a = json?["country_code_is_required"] as? String { Localization.shared.country_code_is_required = a }
                if let a = json?["enter_valid_phone_number"] as? String { Localization.shared.enter_valid_phone_number = a }
                if let a = json?["enter_valid_month"] as? String { Localization.shared.enter_valid_month = a }
                if let a = json?["card_number_is_required"] as? String { Localization.shared.card_number_is_required = a }
                if let a = json?["enter_valid_card_number"] as? String { Localization.shared.enter_valid_card_number = a }
                if let a = json?["last_name_invalid"] as? String { Localization.shared.last_name_invalid = a }
                if let a = json?["first_name_invalid"] as? String { Localization.shared.first_name_invalid = a }
                if let a = json?["last_name_is_required"] as? String { Localization.shared.last_name_is_required = a }
                if let a = json?["first_name_is_required"] as? String { Localization.shared.first_name_is_required = a }
                if let a = json?["enter_valid_name"] as? String { Localization.shared.enter_valid_name = a }
                if let a = json?["enter_valid_email"] as? String { Localization.shared.enter_valid_email = a }
                if let a = json?["recovery_email_is_required"] as? String { Localization.shared.recovery_email_is_required = a }
                if let a = json?["email_is_required"] as? String { Localization.shared.email_is_required = a }
                if let a = json?["passwords_doesn_t_match"] as? String { Localization.shared.passwords_doesn_t_match = a }
                if let a = json?["confirmation_password_is_required"] as? String { Localization.shared.confirmation_password_is_required = a }
                if let a = json?["password_is_required"] as? String { Localization.shared.password_is_required = a }
                if let a = json?["tour_mobile_description_4"] as? String { Localization.shared.tour_mobile_description_4 = a }
                if let a = json?["tour_mobile_title_4"] as? String { Localization.shared.tour_mobile_title_4 = a }
                if let a = json?["tour_mobile_description_3"] as? String { Localization.shared.tour_mobile_description_3 = a }
                if let a = json?["tour_mobile_title_3"] as? String { Localization.shared.tour_mobile_title_3 = a }
                if let a = json?["tour_mobile_description_2"] as? String { Localization.shared.tour_mobile_description_2 = a }
                if let a = json?["tour_mobile_title_2"] as? String { Localization.shared.tour_mobile_title_2 = a }
                if let a = json?["tour_mobile_description_1"] as? String { Localization.shared.tour_mobile_description_1 = a }
                if let a = json?["tour_mobile_title_1"] as? String { Localization.shared.tour_mobile_title_1 = a }
                if let a = json?["tour_desktop_description_5"] as? String { Localization.shared.tour_desktop_description_5 = a }
                if let a = json?["tour_desktop_title_5"] as? String { Localization.shared.tour_desktop_title_5 = a }
                if let a = json?["tour_desktop_description_4"] as? String { Localization.shared.tour_desktop_description_4 = a }
                if let a = json?["tour_desktop_title_4"] as? String { Localization.shared.tour_desktop_title_4 = a }
                if let a = json?["tour_desktop_description_3"] as? String { Localization.shared.tour_desktop_description_3 = a }
                if let a = json?["tour_desktop_title_3"] as? String { Localization.shared.tour_desktop_title_3 = a }
                if let a = json?["tour_desktop_description_2"] as? String { Localization.shared.tour_desktop_description_2 = a }
                if let a = json?["tour_desktop_title_2"] as? String { Localization.shared.tour_desktop_title_2 = a }
                if let a = json?["tour_desktop_description_1"] as? String { Localization.shared.tour_desktop_description_1 = a }
                if let a = json?["tour_desktop_title_1"] as? String { Localization.shared.tour_desktop_title_1 = a }
                if let a = json?["finish"] as? String { Localization.shared.finish = a }
                if let a = json?["skip_tour"] as? String { Localization.shared.skip_tour = a }
                if let a = json?["next"] as? String { Localization.shared.next = a }
                if let a = json?["to_do_filter.scorecard.default"] as? String { Localization.shared.to_do_filter_scorecard_default = a }
                if let a = json?["to_do_filter.scorecard.practises"] as? String { Localization.shared.to_do_filter_scorecard_practises = a }
                if let a = json?["to_do_filter.scorecard.social engineering"] as? String { Localization.shared.to_do_filter_scorecard_social_engineering = a }
                if let a = json?["to_do_filter.scorecard.inappropriate software"] as? String { Localization.shared.to_do_filter_scorecard_inappropriate_software = a }
                if let a = json?["to_do_filter.scorecard.parental controls"] as? String { Localization.shared.to_do_filter_scorecard_parental_controls = a }
                if let a = json?["to_do_filter.scorecard.backup"] as? String { Localization.shared.to_do_filter_scorecard_backup = a }
                if let a = json?["tp_4_1_c"] as? String { Localization.shared.tp_4_1_c = a }
                if let a = json?["tp_4_1_b"] as? String { Localization.shared.tp_4_1_b = a }
                if let a = json?["tp_4_1_a"] as? String { Localization.shared.tp_4_1_a = a }
                if let a = json?["tp_4_1"] as? String { Localization.shared.tp_4_1 = a }
                if let a = json?["tp_4_1_strong"] as? String { Localization.shared.tp_4_1_strong = a }
                if let a = json?["tp_4_strong"] as? String { Localization.shared.tp_4_strong = a }
                if let a = json?["tp_3"] as? String { Localization.shared.tp_3 = a }
                if let a = json?["tp_3_strong"] as? String { Localization.shared.tp_3_strong = a }
                if let a = json?["tp_2_7"] as? String { Localization.shared.tp_2_7 = a }
                if let a = json?["tp_2_6"] as? String { Localization.shared.tp_2_6 = a }
                if let a = json?["tp_2_5"] as? String { Localization.shared.tp_2_5 = a }
                if let a = json?["to_do_filter.scorecard.privacy controls"] as? String { Localization.shared.to_do_filter_scorecard_privacy_controls = a }
                if let a = json?["to_do_filter.scorecard.password management"] as? String { Localization.shared.to_do_filter_scorecard_password_management = a }
                if let a = json?["to_do_filter.scorecard.encryption"] as? String { Localization.shared.to_do_filter_scorecard_encryption = a }
                if let a = json?["to_do_filter.scorecard.security_software"] as? String { Localization.shared.to_do_filter_scorecard_security_software = a }
                if let a = json?["to_do_filter.completed"] as? String { Localization.shared.to_do_filter_completed = a }
                if let a = json?["to_do_filter.to_be_completed"] as? String { Localization.shared.to_do_filter_to_be_completed = a }
                if let a = json?["to_do_filter.information"] as? String { Localization.shared.to_do_filter_information = a }
                if let a = json?["to_do_filter.all_risk"] as? String { Localization.shared.to_do_filter_all_risk = a }
                if let a = json?["to_do_filter.low_risk"] as? String { Localization.shared.to_do_filter_low_risk = a }
                if let a = json?["to_do_filter.medium_risk"] as? String { Localization.shared.to_do_filter_medium_risk = a }
                if let a = json?["to_do_filter.very_high_risk"] as? String { Localization.shared.to_do_filter_very_high_risk = a }
                if let a = json?["to_do_filter.high_risk"] as? String { Localization.shared.to_do_filter_high_risk = a }
                if let a = json?["to_do_filter.priority"] as? String { Localization.shared.to_do_filter_priority = a }
                if let a = json?["qrcode_scan"] as? String { Localization.shared.qrcode_scan = a }
                if let a = json?["the_laptop_you_added_not_active"] as? String { Localization.shared.the_laptop_you_added_not_active = a }
                if let a = json?["payment_history"] as? String { Localization.shared.payment_history = a }
                if let a = json?["device_tasks"] as? String { Localization.shared.device_tasks = a }
                if let a = json?["what_we_scan"] as? String { Localization.shared.what_we_scan = a }
                if let a = json?["scan_label"] as? String { Localization.shared.scan_label = a }
                if let a = json?["passwords_must_contain_a_combination_of"] as? String { Localization.shared.passwords_must_contain_a_combination_of = a }
                if let a = json?["edit_email"] as? String { Localization.shared.edit_email = a }
                if let a = json?["success"] as? String { Localization.shared.success = a }
                if let a = json?["requesting"] as? String { Localization.shared.requesting = a }
                if let a = json?["payment_method"] as? String { Localization.shared.payment_method = a }
                if let a = json?["via_credit_card"] as? String { Localization.shared.via_credit_card = a }
                if let a = json?["problems"] as? String { Localization.shared.problems = a }
                if let a = json?["privacy_policy"] as? String { Localization.shared.privacy_policy = a }
                if let a = json?["terms_and_privacy"] as? String { Localization.shared.terms_and_privacy = a }
                if let a = json?["vulneralilities_scan"] as? String { Localization.shared.vulneralilities_scan = a }
                if let a = json?["vulneralilities_found_subheader"] as? String { Localization.shared.vulneralilities_found_subheader = a }
                if let a = json?["vulneralilities_found_header"] as? String { Localization.shared.vulneralilities_found_header = a }
                if let a = json?["add_discount_subheader"] as? String { Localization.shared.add_discount_subheader = a }
                if let a = json?["don_t_have_a_code"] as? String { Localization.shared.don_t_have_a_code = a }
                if let a = json?["add_discount"] as? String { Localization.shared.add_discount = a }
                if let a = json?["verify_your_device"] as? String { Localization.shared.verify_your_device = a }
                if let a = json?["device_not_verified"] as? String { Localization.shared.device_not_verified = a }
                if let a = json?["device_verified"] as? String { Localization.shared.device_verified = a }
                if let a = json?["device_verifying"] as? String { Localization.shared.device_verifying = a }
                if let a = json?["logged_out_successfully"] as? String { Localization.shared.logged_out_successfully = a }
                if let a = json?["loading_device"] as? String { Localization.shared.loading_device = a }
                if let a = json?["loading_action"] as? String { Localization.shared.loading_action = a }
                if let a = json?["loading_actions"] as? String { Localization.shared.loading_actions = a }
                if let a = json?["loading"] as? String { Localization.shared.loading = a }
                if let a = json?["loading_assessment"] as? String { Localization.shared.loading_assessment = a }
                if let a = json?["loading_plans"] as? String { Localization.shared.loading_plans = a }
                if let a = json?["changing_password"] as? String { Localization.shared.changing_password = a }
                if let a = json?["error_occured"] as? String { Localization.shared.error_occured = a }
                if let a = json?["confirm_password"] as? String { Localization.shared.confirm_password = a }
                if let a = json?["sign_up_with_facebook"] as? String { Localization.shared.sign_up_with_facebook = a }
                if let a = json?["enter_a_password"] as? String { Localization.shared.enter_a_password = a }
                if let a = json?["recovery_email"] as? String { Localization.shared.recovery_email = a }
                if let a = json?["enter_your_name"] as? String { Localization.shared.enter_your_name = a }
                if let a = json?["got_an_account"] as? String { Localization.shared.got_an_account = a }
                if let a = json?["sign_in_with_facebook"] as? String { Localization.shared.sign_in_with_facebook = a }
                if let a = json?["forgot_password"] as? String { Localization.shared.forgot_password = a }
                if let a = json?["delete_phone_warning"] as? String { Localization.shared.delete_phone_warning = a }
                if let a = json?["delete_card_warning"] as? String { Localization.shared.delete_card_warning = a }
                if let a = json?["delete_emails_warning"] as? String { Localization.shared.delete_emails_warning = a }
                if let a = json?["protected_emails_description"] as? String { Localization.shared.protected_emails_description = a }
                if let a = json?["protected_emails"] as? String { Localization.shared.protected_emails = a }
                if let a = json?["add_card"] as? String { Localization.shared.add_card = a }
                if let a = json?["delete_phone_number"] as? String { Localization.shared.delete_phone_number = a }
                if let a = json?["delete_credit_card"] as? String { Localization.shared.delete_credit_card = a }
                if let a = json?["protected_phone_description"] as? String { Localization.shared.protected_phone_description = a }
                if let a = json?["protected_phone_numbers"] as? String { Localization.shared.protected_phone_numbers = a }
                if let a = json?["protected_cards_description"] as? String { Localization.shared.protected_cards_description = a }
                if let a = json?["protected_cards"] as? String { Localization.shared.protected_cards = a }
                if let a = json?["monitor_data"] as? String { Localization.shared.monitor_data = a }
                if let a = json?["add_device"] as? String { Localization.shared.add_device = a }
                if let a = json?["add_phone"] as? String { Localization.shared.add_phone = a }
                if let a = json?["add_phone_number"] as? String { Localization.shared.add_phone_number = a }
                if let a = json?["add_credit_card"] as? String { Localization.shared.add_credit_card = a }
                if let a = json?["disabled_upgrade_plan_to_enable_device"] as? String { Localization.shared.disabled_upgrade_plan_to_enable_device = a }
                if let a = json?["add_email"] as? String { Localization.shared.add_email = a }
                if let a = json?["cvv"] as? String { Localization.shared.cvv = a }
                if let a = json?["expiry_year"] as? String { Localization.shared.expiry_year = a }
                if let a = json?["expiry_month"] as? String { Localization.shared.expiry_month = a }
                if let a = json?["last_name"] as? String { Localization.shared.last_name = a }
                if let a = json?["first_name"] as? String { Localization.shared.first_name = a }
                if let a = json?["full_name"] as? String { Localization.shared.full_name = a }
                if let a = json?["name_your_device"] as? String { Localization.shared.name_your_device = a }
                if let a = json?["search_apps"] as? String { Localization.shared.search_apps = a }
                if let a = json?["enable_2_step_verification"] as? String { Localization.shared.enable_2_step_verification = a }
                if let a = json?["email_already_verified"] as? String { Localization.shared.email_already_verified = a }
                if let a = json?["email_verified"] as? String { Localization.shared.email_verified = a }
                if let a = json?["email_verifying"] as? String { Localization.shared.email_verifying = a }
                if let a = json?["we_sent_an_activation_email_subheader"] as? String { Localization.shared.we_sent_an_activation_email_subheader = a }
                if let a = json?["we_sent_an_activation_email_header"] as? String { Localization.shared.we_sent_an_activation_email_header = a }
                if let a = json?["an_activation_link_has_been_sent"] as? String { Localization.shared.an_activation_link_has_been_sent = a }
                if let a = json?["verify_your_email_header"] as? String { Localization.shared.verify_your_email_header = a }
                if let a = json?["maybe_later"] as? String { Localization.shared.maybe_later = a }
                if let a = json?["upgrade_plan"] as? String { Localization.shared.upgrade_plan = a }
                if let a = json?["enable_scan"] as? String { Localization.shared.enable_scan = a }
                if let a = json?["disabled"] as? String { Localization.shared.disabled = a }
                if let a = json?["enabled"] as? String { Localization.shared.enabled = a }
                if let a = json?["start_scan"] as? String { Localization.shared.start_scan = a }
                if let a = json?["run_some_scans_to_check"] as? String { Localization.shared.run_some_scans_to_check = a }
                if let a = json?["your_cyber_security_score_tip_dashboard"] as? String { Localization.shared.your_cyber_security_score_tip_dashboard = a }
                if let a = json?["your_cyber_security_score_tip"] as? String { Localization.shared.your_cyber_security_score_tip = a }
                if let a = json?["risk_excellent"] as? String { Localization.shared.risk_excellent = a }
                if let a = json?["risk_very_good"] as? String { Localization.shared.risk_very_good = a }
                if let a = json?["risk_good"] as? String { Localization.shared.risk_good = a }
                if let a = json?["risk_fair"] as? String { Localization.shared.risk_fair = a }
                if let a = json?["risk_very_poor"] as? String { Localization.shared.risk_very_poor = a }
                if let a = json?["risk_medium"] as? String { Localization.shared.risk_medium = a }
                if let a = json?["your_cyber_security_score"] as? String { Localization.shared.your_cyber_security_score = a }
                if let a = json?["error_loading_devices"] as? String { Localization.shared.error_loading_devices = a }
                if let a = json?["risk_loading_error"] as? String { Localization.shared.risk_loading_error = a }
                if let a = json?["risk_loading"] as? String { Localization.shared.risk_loading = a }
                if let a = json?["type_new_password"] as? String { Localization.shared.type_new_password = a }
                if let a = json?["resetting_password_error"] as? String { Localization.shared.resetting_password_error = a }
                if let a = json?["reset_password_error"] as? String { Localization.shared.reset_password_error = a }
                if let a = json?["reset_password_sent_subheader"] as? String { Localization.shared.reset_password_sent_subheader = a }
                if let a = json?["reset_and_sign_in"] as? String { Localization.shared.reset_and_sign_in = a }
                if let a = json?["reset_password_success"] as? String { Localization.shared.reset_password_success = a }
                if let a = json?["resetting_password"] as? String { Localization.shared.resetting_password = a }
                if let a = json?["reset_your_password"] as? String { Localization.shared.reset_your_password = a }
                if let a = json?["reset_password_sent"] as? String { Localization.shared.reset_password_sent = a }
                if let a = json?["reset_password_sending"] as? String { Localization.shared.reset_password_sending = a }
                if let a = json?["new_to_dynarisk"] as? String { Localization.shared.new_to_dynarisk = a }
                if let a = json?["general_assessment_subheader"] as? String { Localization.shared.general_assessment_subheader = a }
                if let a = json?["general_assessment"] as? String { Localization.shared.general_assessment = a }
                if let a = json?["email_already_registered"] as? String { Localization.shared.email_already_registered = a }
                if let a = json?["are_you_already_registered"] as? String { Localization.shared.are_you_already_registered = a }
                if let a = json?["are_you_not_registered"] as? String { Localization.shared.are_you_not_registered = a }
                if let a = json?["sign_in_to_dynarisk_subheader"] as? String { Localization.shared.sign_in_to_dynarisk_subheader = a }
                if let a = json?["sign_in_to_dynarisk_facebook_subheader"] as? String { Localization.shared.sign_in_to_dynarisk_facebook_subheader = a }
                if let a = json?["action_data_breach_subheader"] as? String { Localization.shared.action_data_breach_subheader = a }
                if let a = json?["action_data_breach_header"] as? String { Localization.shared.action_data_breach_header = a }
                if let a = json?["continue_as"] as? String { Localization.shared.continue_as = a }
                if let a = json?["delete_account_warning"] as? String { Localization.shared.delete_account_warning = a }
                if let a = json?["reason_for_deleting_your_account"] as? String { Localization.shared.reason_for_deleting_your_account = a }
                if let a = json?["delete_account"] as? String { Localization.shared.delete_account = a }
                if let a = json?["router_scan"] as? String { Localization.shared.router_scan = a }
                if let a = json?["vulnerability_scan"] as? String { Localization.shared.vulnerability_scan = a }
                if let a = json?["data_breach_scanner"] as? String { Localization.shared.data_breach_scanner = a }
                if let a = json?["security_news"] as? String { Localization.shared.security_news = a }
                if let a = json?["special_offers"] as? String { Localization.shared.special_offers = a }
                if let a = json?["data_breach_reports"] as? String { Localization.shared.data_breach_reports = a }
                if let a = json?["change_payment_method"] as? String { Localization.shared.change_payment_method = a }
                if let a = json?["about_ssl_certificates"] as? String { Localization.shared.about_ssl_certificates = a }
                if let a = json?["activate_payment_method"] as? String { Localization.shared.activate_payment_method = a }
                if let a = json?["personal_information"] as? String { Localization.shared.personal_information = a }
                if let a = json?["vulnerability_alerts"] as? String { Localization.shared.vulnerability_alerts = a }
                if let a = json?["setting"] as? String { Localization.shared.setting = a }
                if let a = json?["phone_is_required"] as? String { Localization.shared.phone_is_required = a }
                if let a = json?["message_is_short"] as? String { Localization.shared.message_is_short = a }
                if let a = json?["message_is_required"] as? String { Localization.shared.message_is_required = a }
                if let a = json?["name_is_required"] as? String { Localization.shared.name_is_required = a }
                if let a = json?["subject_is_required"] as? String { Localization.shared.subject_is_required = a }
                if let a = json?["message"] as? String { Localization.shared.message = a }
                if let a = json?["send"] as? String { Localization.shared.send = a }
                if let a = json?["sign_in_to_dynarisk"] as? String { Localization.shared.sign_in_to_dynarisk = a }
                if let a = json?["welcome_to_dynarisk"] as? String { Localization.shared.welcome_to_dynarisk = a }
                if let a = json?["sign_up_to_dynarisk"] as? String { Localization.shared.sign_up_to_dynarisk = a }
                if let a = json?["log_out"] as? String { Localization.shared.log_out = a }
                if let a = json?["sign_in"] as? String { Localization.shared.sign_in = a }
                if let a = json?["return_to_sign_in"] as? String { Localization.shared.return_to_sign_in = a }
                if let a = json?["sign_up"] as? String { Localization.shared.sign_up = a }
                if let a = json?["need_more_help"] as? String { Localization.shared.need_more_help = a }
                if let a = json?["try_trial"] as? String { Localization.shared.try_trial = a }
                if let a = json?["free"] as? String { Localization.shared.free = a }
                if let a = json?["postponed"] as? String { Localization.shared.postponed = a }
                if let a = json?["overdue"] as? String { Localization.shared.overdue = a }
                if let a = json?["dashboard"] as? String { Localization.shared.dashboard = a }
                if let a = json?["all_devices"] as? String { Localization.shared.all_devices = a }
                if let a = json?["device_filter_placeholder"] as? String { Localization.shared.device_filter_placeholder = a }
                if let a = json?["priority_filter_placeholder"] as? String { Localization.shared.priority_filter_placeholder = a }
                if let a = json?["status_filter_placeholder"] as? String { Localization.shared.status_filter_placeholder = a }
                if let a = json?["to_do_list_filters"] as? String { Localization.shared.to_do_list_filters = a }
                if let a = json?["devices"] as? String { Localization.shared.devices = a }
                if let a = json?["emails"] as? String { Localization.shared.emails = a }
                if let a = json?["x_tasks"] as? String { Localization.shared.x_tasks = a }
                if let a = json?["none"] as? String { Localization.shared.none = a }
                if let a = json?["apply_code"] as? String { Localization.shared.apply_code = a }
                if let a = json?["remember_me"] as? String { Localization.shared.remember_me = a }
                if let a = json?["new_password"] as? String { Localization.shared.new_password = a }
                if let a = json?["old_password"] as? String { Localization.shared.old_password = a }
                if let a = json?["repeat_new_password"] as? String { Localization.shared.repeat_new_password = a }
                if let a = json?["change_password"] as? String { Localization.shared.change_password = a }
                if let a = json?["password"] as? String { Localization.shared.password = a }
                if let a = json?["additional_options_header"] as? String { Localization.shared.additional_options_header = a }
                if let a = json?["steps"] as? String { Localization.shared.steps = a }
                if let a = json?["instructions_header"] as? String { Localization.shared.instructions_header = a }
                if let a = json?["why_ti_is_necessary"] as? String { Localization.shared.why_ti_is_necessary = a }
                if let a = json?["data_breaches_scan_subheader"] as? String { Localization.shared.data_breaches_scan_subheader = a }
                if let a = json?["data_breaches_scan_header"] as? String { Localization.shared.data_breaches_scan_header = a }
                if let a = json?["device_vulnerability_subheader"] as? String { Localization.shared.device_vulnerability_subheader = a }
                if let a = json?["device_vulnerability_header"] as? String { Localization.shared.device_vulnerability_header = a }
                if let a = json?["account_vulnerability_subheader"] as? String { Localization.shared.account_vulnerability_subheader = a }
                if let a = json?["account_vulnerability_header"] as? String { Localization.shared.account_vulnerability_header = a }
                if let a = json?["performing_a_router_scan_subheader"] as? String { Localization.shared.performing_a_router_scan_subheader = a }
                if let a = json?["performing_a_router_scan"] as? String { Localization.shared.performing_a_router_scan = a }
                if let a = json?["support_subheader"] as? String { Localization.shared.support_subheader = a }
                if let a = json?["support"] as? String { Localization.shared.support = a }
                if let a = json?["download_app_subheader"] as? String { Localization.shared.download_app_subheader = a }
                if let a = json?["can_t_be_activated"] as? String { Localization.shared.can_t_be_activated = a }
                if let a = json?["device_limit_reached"] as? String { Localization.shared.device_limit_reached = a }
                if let a = json?["upgrade_to_add_more_devices"] as? String { Localization.shared.upgrade_to_add_more_devices = a }
                if let a = json?["reached_device_limit"] as? String { Localization.shared.reached_device_limit = a }
                if let a = json?["error_call_limit"] as? String { Localization.shared.error_call_limit = a }
                if let a = json?["call_limit"] as? String { Localization.shared.call_limit = a }
                if let a = json?["download_app"] as? String { Localization.shared.download_app = a }
                if let a = json?["call_us"] as? String { Localization.shared.call_us = a }
                if let a = json?["pending"] as? String { Localization.shared.pending = a }
                if let a = json?["active"] as? String { Localization.shared.active = a }
                if let a = json?["actions_tasks"] as? String { Localization.shared.actions_tasks = a }
                if let a = json?["to_do"] as? String { Localization.shared.to_do = a }
                if let a = json?["how_to_do_it"] as? String { Localization.shared.how_to_do_it = a }
                if let a = json?["not_sure"] as? String { Localization.shared.not_sure = a }
                if let a = json?["yes"] as? String { Localization.shared.yes = a }
                if let a = json?["no"] as? String { Localization.shared.no = a }
                if let a = json?["save"] as? String { Localization.shared.save = a }
                if let a = json?["resend_activation_email"] as? String { Localization.shared.resend_activation_email = a }
                if let a = json?["resend_activation_link"] as? String { Localization.shared.resend_activation_link = a }
                if let a = json?["wrong_os_device"] as? String { Localization.shared.wrong_os_device = a }
                if let a = json?["dashboard_copy.the_laptop_you_added_has_been_activated_but_assessment_is_not_answered"] as? String { Localization.shared.dashboard_copy_the_laptop_you_added_has_been_activated_but_assessment_is_not_answered = a }
                if let a = json?["dashboard_copy.the_device_you_added_is_active_now"] as? String { Localization.shared.dashboard_copy_the_device_you_added_is_active_now = a }
                if let a = json?["dashboard_copy.the_laptop_you_added_has_not_been_activated_yet"] as? String { Localization.shared.dashboard_copy_the_laptop_you_added_has_not_been_activated_yet = a }
                if let a = json?["upgrade_plane_pay.contact"] as? String { Localization.shared.upgrade_plane_pay_contact = a }
                if let a = json?["upgrade_plane_standard.select_plan"] as? String { Localization.shared.upgrade_plane_standard_select_plan = a }
                if let a = json?["dashboard.tasks.item_remind_later"] as? String { Localization.shared.dashboard_tasks_item_remind_later = a }
                if let a = json?["dashboard.tasks_list_everything_ok"] as? String { Localization.shared.dashboard_tasks_list_everything_ok = a }
                if let a = json?["dashboard.tasks_view_all"] as? String { Localization.shared.dashboard_tasks_view_all = a }
                if let a = json?["dashboard.tasks.what_to_do"] as? String { Localization.shared.dashboard_tasks_what_to_do = a }
                if let a = json?["monitored_data"] as? String { Localization.shared.monitored_data = a }
                if let a = json?["dashboard.manage_monitored_data"] as? String { Localization.shared.dashboard_manage_monitored_data = a }
                if let a = json?["dashboard.manage_devices"] as? String { Localization.shared.dashboard_manage_devices = a }
                if let a = json?["dashboard.to_do"] as? String { Localization.shared.dashboard_to_do = a }
                if let a = json?["continue_to_dashboard"] as? String { Localization.shared.continue_to_dashboard = a }
                if let a = json?["dashboard.dashboard"] as? String { Localization.shared.dashboard_dashboard = a }
                if let a = json?["reset_password"] as? String { Localization.shared.reset_password = a }
                if let a = json?["change_email"] as? String { Localization.shared.change_email = a }
                if let a = json?["change_plan"] as? String { Localization.shared.change_plan = a }
                if let a = json?["continue"] as? String { Localization.shared.continue_ = a }
                if let a = json?["view_device"] as? String { Localization.shared.view_device = a }
                if let a = json?["cancel"] as? String { Localization.shared.cancel = a }
                if let a = json?["name"] as? String { Localization.shared.name = a }
                if let a = json?["email_address"] as? String { Localization.shared.email_address = a }
                if let a = json?["card_number"] as? String { Localization.shared.card_number = a }
                if let a = json?["credit_card"] as? String { Localization.shared.credit_card = a }
                if let a = json?["phone_number"] as? String { Localization.shared.phone_number = a }
                if let a = json?["protected"] as? String { Localization.shared.protected = a }
                if let a = json?["delete"] as? String { Localization.shared.delete = a }
                if let a = json?["add"] as? String { Localization.shared.add = a }
                if let a = json?["two_weeks"] as? String { Localization.shared.two_weeks = a }
                if let a = json?["five_days"] as? String { Localization.shared.five_days = a }
                if let a = json?["one_day"] as? String { Localization.shared.one_day = a }
                if let a = json?["powered_by"] as? String { Localization.shared.powered_by = a }
                if let a = json?["month_name.december"] as? String { Localization.shared.month_name_december = a }
                if let a = json?["month_name.november"] as? String { Localization.shared.month_name_november = a }
                if let a = json?["month_name.october"] as? String { Localization.shared.month_name_october = a }
                if let a = json?["month_name.september"] as? String { Localization.shared.month_name_september = a }
                if let a = json?["month_name.august"] as? String { Localization.shared.month_name_august = a }
                if let a = json?["month_name.july"] as? String { Localization.shared.month_name_july = a }
                if let a = json?["month_name.june"] as? String { Localization.shared.month_name_june = a }
                if let a = json?["month_name.may"] as? String { Localization.shared.month_name_may = a }
                if let a = json?["month_name.april"] as? String { Localization.shared.month_name_april = a }
                if let a = json?["month_name.march"] as? String { Localization.shared.month_name_march = a }
                if let a = json?["month_name.february"] as? String { Localization.shared.month_name_february = a }
                if let a = json?["month_name.january"] as? String { Localization.shared.month_name_january =  a }
                if let a = json?["day_of_week.sartuday"] as? String { Localization.shared.day_of_week_sartuday = a }
                if let a = json?["day_of_week.friday"] as? String { Localization.shared.day_of_week_friday = a }
                if let a = json?["day_of_week.thursday"] as? String { Localization.shared.day_of_week_thursday = a }
                if let a = json?["day_of_week.wednesday"] as? String { Localization.shared.day_of_week_wednesday = a }
                if let a = json?["day_of_week.tuesday"] as? String { Localization.shared.day_of_week_tuesday = a }
                if let a = json?["day_of_week.monday"] as? String { Localization.shared.day_of_week_monday = a }
                if let a = json?["day_of_week.sunday"] as? String { Localization.shared.day_of_week_sunday = a }
                if let a = json?["remind_me_later"] as? String { Localization.shared.remind_me_later = a }
                if let a = json?["device_type.laptop"] as? String { Localization.shared.device_type_laptop = a }
                if let a = json?["device_type.desktop"] as? String { Localization.shared.device_type_desktop = a }
                if let a = json?["device_type.tablet"] as? String { Localization.shared.device_type_tablet = a }
                if let a = json?["device_type.phone"] as? String { Localization.shared.device_type_phone = a }
                if let a = json?["device_type.pc"] as? String { Localization.shared.device_type_pc = a }
                if let a = json?["confirm_delition_email"] as? String { Localization.shared.confirm_delition_email = a }
                if let a = json?["data_email"] as? String { Localization.shared.data_email = a }
                if let a = json?["data_emails"] as? String { Localization.shared.data_emails = a }
                if let a = json?["data_card"] as? String { Localization.shared.data_card = a }
                if let a = json?["data_cards"] as? String { Localization.shared.data_cards = a }
                if let a = json?["data_phone"] as? String { Localization.shared.data_phone = a }
                if let a = json?["data_phones"] as? String { Localization.shared.data_phones = a }
                if let a = json?["data_no_data"] as? String { Localization.shared.data_no_data = a }
                if let a = json?["data_no_data_is_available_right_now_new_data_will_show_"] as? String { Localization.shared.data_no_data_is_available_right_now_new_data_will_show_ = a }
                if let a = json?["data_your_data_has_been_added_but_it_s_not_active_yet"] as? String { Localization.shared.data_your_data_has_been_added_but_it_s_not_active_yet = a }
                if let a = json?["settings_change_language"] as? String { Localization.shared.settings_change_language = a }
                if let a = json?["settings_email_notification"] as? String { Localization.shared.settings_email_notification = a }
                if let a = json?["settings_are_you_sure_you_want_to_log_out_"] as? String { Localization.shared.settings_are_you_sure_you_want_to_log_out_ = a }
                if let a = json?["settings_type_your_current_password"] as? String { Localization.shared.settings_type_your_current_password = a }
                if let a = json?["settings_retype_new_password"] as? String { Localization.shared.settings_retype_new_password = a }
                if let a = json?["settings_password_can_t_be_empty"] as? String { Localization.shared.settings_password_can_t_be_empty = a }
                if let a = json?["settings_password_doesn_t_match"] as? String { Localization.shared.settings_password_doesn_t_match = a }
                if let a = json?["settings_password_too_short_add_number_chars_"] as? String { Localization.shared.settings_password_too_short_add_number_chars_ = a }
                if let a = json?["settings_password_must_contain_lower_case_letters"] as? String { Localization.shared.settings_password_must_contain_lower_case_letters = a }
                if let a = json?["settings_password_must_contain_upper_case_letters"] as? String { Localization.shared.settings_password_must_contain_upper_case_letters = a }
                if let a = json?["settings_add_at_least_one_special_character"] as? String { Localization.shared.settings_add_at_least_one_special_character = a }
                if let a = json?["settings_add_at_least_one_digit"] as? String { Localization.shared.settings_add_at_least_one_digit = a }
                if let a = json?["settings_use_at_least_8_characters_and_include_upper_and_lo"] as? String { Localization.shared.settings_use_at_least_8_characters_and_include_upper_and_lo = a }
                if let a = json?["settings_ok"] as? String { Localization.shared.settings_ok = a }
                if let a = json?["settings_you_have_to_include_a_reason"] as? String { Localization.shared.settings_you_have_to_include_a_reason = a }
                if let a = json?["settings_your_account_is_deleted_we_re_sorry_to_see_you_go"] as? String { Localization.shared.settings_your_account_is_deleted_we_re_sorry_to_see_you_go = a }
                if let a = json?["assessment_start"] as? String { Localization.shared.assessment_start = a }
                if let a = json?["assessment_almost_done"] as? String { Localization.shared.assessment_almost_done = a }
                if let a = json?["assessment_assessing_your_risk"] as? String { Localization.shared.assessment_assessing_your_risk = a }
                if let a = json?["assessment_you_must_select_at_least_one"] as? String { Localization.shared.assessment_you_must_select_at_least_one = a }
                if let a = json?["assessment_redirecting_to"] as? String { Localization.shared.assessment_redirecting_to = a }
                if let a = json?["assessment_your_assessment_is_now_complete_we_will_generate_a"] as? String { Localization.shared.assessment_your_assessment_is_now_complete_we_will_generate_a = a }
                if let a = json?["assessment_all_done"] as? String { Localization.shared.assessment_all_done = a }
                if let a = json?["to_set_a_reminder"] as? String { Localization.shared.to_set_a_reminder = a }
                if let a = json?["to_in_1_day"] as? String { Localization.shared.to_in_1_day = a }
                if let a = json?["to_in_days_days"] as? String { Localization.shared.to_in_days_days = a }
                if let a = json?["to_in_weeks_weeks"] as? String { Localization.shared.to_in_weeks_weeks = a }
                if let a = json?["to_filter_tasks"] as? String { Localization.shared.to_filter_tasks = a }
                if let a = json?["to_reminder_set_for_1_week"] as? String { Localization.shared.to_reminder_set_for_1_week = a }
                if let a = json?["to_reminder_set_for_weeks_weeks"] as? String { Localization.shared.to_reminder_set_for_weeks_weeks = a }
                if let a = json?["to_reminder_set_for_1_day"] as? String { Localization.shared.to_reminder_set_for_1_day = a }
                if let a = json?["to_reminder_set_for_days_days"] as? String { Localization.shared.to_reminder_set_for_days_days = a }
                if let a = json?["to_due_in_days_days"] as? String { Localization.shared.to_due_in_days_days = a }
                if let a = json?["to_due_in_1_day"] as? String { Localization.shared.to_due_in_1_day = a }
                if let a = json?["to_reminder_set_for"] as? String { Localization.shared.to_reminder_set_for = a }
                if let a = json?["to_clear_filter"] as? String { Localization.shared.to_clear_filter = a }
                if let a = json?["to_you_have_no_tasks_in_your_to_do_list_check_once_in"] as? String { Localization.shared.to_you_have_no_tasks_in_your_to_do_list_check_once_in = a }
                if let a = json?["to_accounts_exposed"] as? String { Localization.shared.to_accounts_exposed = a }
                if let a = json?["to_tap_here_to_see_your_raw_breached_data"] as? String { Localization.shared.to_tap_here_to_see_your_raw_breached_data = a }
                if let a = json?["to_make_sure_you_are_in_a_private_place_the_data_you_"] as? String { Localization.shared.to_make_sure_you_are_in_a_private_place_the_data_you_ = a }
                if let a = json?["to_search_apps"] as? String { Localization.shared.to_search_apps = a }
                if let a = json?["to_visit_website"] as? String { Localization.shared.to_visit_website = a }
                if let a = json?["to_your_trial_has_started"] as? String { Localization.shared.to_your_trial_has_started = a }
                if let a = json?["scans_scans_have_finished_all_tasks_please_wait_as_you_w"] as? String { Localization.shared.scans_scans_have_finished_all_tasks_please_wait_as_you_w = a }
                if let a = json?["scans_loading_assessment"] as? String { Localization.shared.scans_loading_assessment = a }
                if let a = json?["support_finding_a_solution_by_your_own"] as? String { Localization.shared.support_finding_a_solution_by_your_own = a }
                if let a = json?["support_call_us_now"] as? String { Localization.shared.support_call_us_now = a }
                if let a = json?["support_working_hours_8_00_-_13_00"] as? String { Localization.shared.support_working_hours_8_00__13_00 = a }
                if let a = json?["menu_data"] as? String { Localization.shared.menu_data = a }
                if let a = json?["menu_support"] as? String { Localization.shared.menu_support = a }
                if let a = json?["device_activating_device_name_"] as? String { Localization.shared.device_activating_device_name_ = a }
                if let a = json?["device_activating_device"] as? String { Localization.shared.device_activating_device = a }
                if let a = json?["device_done"] as? String { Localization.shared.device_done = a }
                if let a = json?["onboarding_what_s_your_email_"] as? String { Localization.shared.onboarding_what_s_your_email_ = a }
                if let a = json?["onboarding_can_t_leave_email_empty"] as? String { Localization.shared.onboarding_can_t_leave_email_empty = a }
                if let a = json?["onboarding_bad_email_format"] as? String { Localization.shared.onboarding_bad_email_format = a }
                if let a = json?["onboarding_something_went_wrong_please_contact_cyberx_asap_"] as? String { Localization.shared.onboarding_something_went_wrong_please_contact_cyberx_asap_ = a }
                if let a = json?["name_what_s_your_name_"] as? String { Localization.shared.name_what_s_your_name_ = a }
                if let a = json?["name_can_t_be_less_than_3_characters"] as? String { Localization.shared.name_can_t_be_less_than_3_characters = a }
                if let a = json?["name_can_t_use_special_characters"] as? String { Localization.shared.name_can_t_use_special_characters = a }
                if let a = json?["phone_what_s_your_phone_number_"] as? String { Localization.shared.phone_what_s_your_phone_number_ = a }
                if let a = json?["password_choose_your_password"] as? String { Localization.shared.password_choose_your_password = a }
                if let a = json?["password_password_must_contain_lower_case_letters"] as? String { Localization.shared.password_password_must_contain_lower_case_letters = a }
                if let a = json?["password_password_must_contain_upper_case_letters"] as? String { Localization.shared.password_password_must_contain_upper_case_letters = a }
                if let a = json?["password_add_at_least_one_special_character"] as? String { Localization.shared.password_add_at_least_one_special_character = a }
                if let a = json?["password_add_at_least_one_digit"] as? String { Localization.shared.password_add_at_least_one_digit = a }
                if let a = json?["terms_these_terms"] as? String { Localization.shared.terms_terms_conditions = a }
                if let a = json?["verify_verify_your_email"] as? String { Localization.shared.verify_verify_your_email = a }
                if let a = json?["coupon_got_a_coupon_"] as? String { Localization.shared.coupon_got_a_coupon_ = a }
                if let a = json?["edit_what_s_your_email_"] as? String { Localization.shared.edit_what_s_your_email_ = a }
                if let a = json?["forgot_find_your_password"] as? String { Localization.shared.forgot_find_your_password = a }
                if let a = json?["forgot_recover_password"] as? String { Localization.shared.forgot_recover_password = a }
                if let a = json?["forgot_our_support_is_always_there_in_case_you_need_help_"] as? String { Localization.shared.forgot_our_support_is_always_there_in_case_you_need_help_ = a }
                if let a = json?["forgot_get_in_touch_with_our_team_of_cyber_security_exper"] as? String { Localization.shared.forgot_get_in_touch_with_our_team_of_cyber_security_exper = a }
                if let a = json?["forgot_add_coupon"] as? String { Localization.shared.forgot_add_coupon = a }
                if let a = json?["forgot_coupon_code"] as? String { Localization.shared.forgot_coupon_code = a }
                if let a = json?["forgot_message_sent_successfully_"] as? String { Localization.shared.forgot_message_sent_successfully_ = a }
                if let a = json?["forgot_our_customer_support_will_get_back_to_you_via_emai"] as? String { Localization.shared.forgot_our_customer_support_will_get_back_to_you_via_emai = a }
                if let a = json?["forgot_security_is_our_main_concern_this_message_is_priva"] as? String { Localization.shared.forgot_security_is_our_main_concern_this_message_is_priva = a }
                if let a = json?["forgot_os_at_latest_version"] as? String { Localization.shared.forgot_os_at_latest_version = a }
                if let a = json?["forgot_jail_break_check"] as? String { Localization.shared.forgot_jail_break_check = a }
                if let a = json?["forgot_screen_lock_enabled"] as? String { Localization.shared.forgot_screen_lock_enabled = a }
                if let a = json?["language_changed_header"] as? String { Localization.shared.language_changed_header = a }
                if let a = json?["language_changed_subheader"] as? String { Localization.shared.language_changed_subheader = a }
                if let a = json?["new_device_use_app_header"] as? String { Localization.shared.new_device_use_app_header = a }
                if let a = json?["new_device_use_app_subheader"] as? String { Localization.shared.new_device_use_app_subheader = a }
                if let a = json?["dashboard_device_not_active"] as? String { Localization.shared.dashboard_device_not_active = a; }
                if let a = json?["data_registration_email_"] as? String { Localization.shared.data_registration_email_ = a; }
                if let a = json?["data_family_member_s_email_"] as? String { Localization.shared.data_family_member_s_email_ = a; }
                if let a = json?["data_ok_got_it"] as? String { Localization.shared.data_ok_got_it = a; }
                if let a = json?["data_email_can_t_be_empty_please_try_again"] as? String { Localization.shared.data_email_can_t_be_empty_please_try_again = a; }
                if let a = json?["data_phone_can_t_be_empty_please_try_again"] as? String { Localization.shared.data_phone_can_t_be_empty_please_try_again = a; }
                if let a = json?["data_credit_card_can_t_be_empty_please_try_again"] as? String { Localization.shared.data_credit_card_can_t_be_empty_please_try_again = a; }
                if let a = json?["navigate_to_login"] as? String { Localization.shared.navigate_to_login = a }
                if let a = json?["support_working_hours_8_00__17_00"] as? String { Localization.shared.support_working_hours_8_00__17_00 = a }
                if let a = json?["name_can_t_be_less_than_2_characters"] as? String { Localization.shared.name_can_t_be_less_than_2_characters = a }
                if let a = json?["passed_plan"] as? String { Localization.shared.passed_plan = a }
                if let a = json?["apple_id_has_plan_enabled"] as? String { Localization.shared.apple_id_has_plan_enabled = a }
                if let a = json?["restore_not_available"] as? String { Localization.shared.restore_not_available = a }
                if let a = json?["plan_restored"] as? String { Localization.shared.plan_restored = a }
                if let a = json?["plan_will_renew_on_date"] as? String { Localization.shared.plan_will_renew_on_date = a }
                if let a = json?["restore"] as? String { Localization.shared.restore = a }
                if let a = json?["system_data_access"] as? String { Localization.shared.system_data_access = a }
                if let a = json?["year"] as? String { Localization.shared.year = a }
                if let a = json?["personal_data_scans_info"] as? String { Localization.shared.personal_data_scans_info = a }
                if let a = json?["router_for_vulnerabilities"] as? String { Localization.shared.router_for_vulnerabilities = a }
                if let a = json?["device_for_vulnerabilities"] as? String { Localization.shared.device_for_vulnerabilities = a }
                if let a = json?["email_address_for_breaches"] as? String { Localization.shared.email_address_for_breaches = a }
                if let a = json?["email_in_use"] as? String { Localization.shared.email_in_use = a }
            }
            completion(error == nil)
        }
    }
}

extension String {
    func doubleBracketReplace(with string : String) -> String {
        let newString = self
        if let regex = try? NSRegularExpression(pattern: "[\\{]+([^}]+)[}]+", options: .caseInsensitive) {
            let modString = regex.stringByReplacingMatches(in: newString, options: [], range: NSRange(location: 0, length:  newString.count), withTemplate: string)
            return modString
        }
        return newString
    }
}
