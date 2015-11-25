class CreateTermsPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/terms',
      :template_path => '/pages/simple.html.slim',
      :variables => {:markdown => true},
      :noindex => true
    )
    page.publish!

    description = <<-EOS
## Fame &amp; Partners Terms of Service, Use and Purchase.

Welcome to Fame &amp; Partners! This Web site located at www.fameandpartners.com (this "Site") is owned and operated by Fame &amp; Partners Pty Ltd ("Company"). This Site and any purchases made through this Site are governed by the terms of service, use and purchase described below ("Terms").

Fame &amp; Partners is committed to ensuring every girl discovers and crafts the coolest and most individual look for her special occasion. We were founded in Bondi Beach, Australia but now have offices in New York as well. We ship internationally with a secure courier service and have customer service on call to work with our customers, wherever they may be. Enjoy your shopping experience with Fame &amp; Partners and don't be afraid to give us feedback via our [Contact Form][1]

By using this Site, purchasing products and services through this Site, you agree to be bound by these terms, so please review this entire page carefully. These terms are designed to clearly provide you with a description of the Fame &amp; Partners general terms and conditions regarding purchasing products and services from Fame &amp; Partners and use of this Site

You must be at least 15 years old to purchase Fame &amp; Partners products from this Site or use the Fame &amp; Partners services. The Company reserves the right in its discretion to revise the Terms from time to time so please check back here periodically for updates. By continuing to use or purchase products from this Site and/or by remaining a member of the Fame &amp; Partners Membership Program, you accept and agree to the Company's right to revise the Terms from time to time and to be bound by such changes, so long as they are promptly posted on the Site. If you do not wish to be bound to these Terms (or any revisions to these Terms), please do not use this Site or the Company's services and immediately cancel your Fame &amp; Partners Membership via our [Contact Form][1]

## SHIPPING

Shipping and handling charges are based on your subtotal order amount, calculated after applicable discounts and before sales tax. Standard shipping rates are calculated as follows:

| Item                        | Australia                   | U.S.A                       | U.K.                        | Rest of World                |
| --------------------------- | --------------------------- | --------------------------- | --------------------------- | ---------------------------- |
| ON DEMAND, EXPRESS MAKING   | FREE 3 – 5 Business Days    | FREE 3 – 5 Business Days    | FREE 3 – 5 Business Days    | $30.00 5 – 8 Business Days   |
| ON DEMAND, STANDARD DRESS   | FREE 7 – 10 Business Days   | FREE 7 – 10 Business Days   | FREE 7 – 10 Business Days   | $30.00 7 – 10 Business Days  |
| ON DEMAND, CUSTOMIZED DRESS | FREE 10 - 14 Business Days  | FREE 10 - 14 Business Days  | FREE 10 - 14 Business Days  | $30.00 10 – 14 Business Days |
| ON SALE                     | $11.70 7 – 10 Business Days | $11.70 7 – 10 Business Days | $11.70 7 – 10 Business Days | $30.00 7 – 10 Business Days  |

As soon as your order ships, you will be provided with a tracking number. You can find your order details and tracking information on the My Orders tab within the Account Settings section.

All orders with sale items will be charged a shipping fee of $11.70.

## RETURNS &amp; EXCHANGES

If for any reason you are not happy with your selection, you can exchange an item for another item, or return it for a refund, subject to the following terms and limitations:

* You can exchange your purchase for another item, or return it for a refund within 30 days of purchase, unless you acquired it/them with a Fame &amp; Partners credit. Any items acquired with a Fame &amp; Partners credit can only be exchanged or returned for a credit.
* We only accept returns or exchanges up to 30 days from the original date of shipment. Any item to be returned or exchanged must be in new, unused and resalable condition, with the DO NOT REMOVE tag still attached in the same place as originally sent. We photograph every product as part of our QA process so we know where the DO NOT REMOVE tag was attached. Any exchange or return should be sent back in the original, undamaged packaging, plus any accessories or extras that may have been included with the shipment. For full priced garments, we do not charge a restocking fee unless they are customised. For any discounted items, including but not limited to sale items and items purchased with a discount code we charge a $14.95 restocking fee, when returned for a refund. Items exchanged for another item or returned for a credit are not charged a restocking fee.
* If you purchase multiple sizes in one style/colour we will only accept an exchange for the returning sizes. We do not offer refunds if you are returning for this reason. If you are confused about your size, simply contact our friendly customer service team via our [Contact Form][1] to assist you in working out best fit for you.
* If your purchase includes more than 1 style in the same size, we can only offer a full refund for 1 style; if you would like to return more from this order, we can offer an exchange or credit if you meet all other returns criteria.
* If your single item purchase does not fit as expected, we will accept a return or exchange at any time up to 90 days from the original date of shipment or provide you with a voucher exchangeable up to the value of $50 towards alterations with our alterations partner.

To make a return or exchange, please follow these steps:

1. If you just want to return, you can do so for free (up to $8.25 - when receipt of postage is attached), as long as you are within our returns guidelines.
2. We only accept returns or exchanges up to 30 days from the original date of shipment.
3. We accept returns or exchanges on single item purchases that do not fit for up to 90 days from the original date of shipment or provide a voucher exchangeable up to the value of $50 towards alterations.
4. Any item to be returned or exchanged must be in new, unused and resalable condition, with the DO NOT REMOVE tag still attached in the same place as originally sent. We photograph every product as part of our QA process so we know where the DO NOT REMOVE tag was attached.
5. Any exchange or return should be sent back in the original, undamaged packaging, plus any accessories or extras that may have been included with the shipment.
6. For full priced garments, we do not charge a restocking fee unless they have been customised.
7. For any custom garments (customizations or custom colors), we charge a 50% restocking fee. This is because we are unable to sell a customised dress to another consumer at full retail value.
8. If a customized dress is exchanged for a non-customized dress, which is then returned, a 50% restocking fee will apply to the final return.
9. For any discounted items, we charge a $14.95 restocking fee when returned for a refund.
10. We cannot refund sale items that have been discounted 50% or more.
11. For any items discounted to under $149.00, you will be responsible for covering the cost of the return.
12. Items exchanged for another item or returned for a credit are not charged a restocking fee.
13. We are not responsible for any goods that are returned to us by mistake or are lost.
14. Maximum of one exchange allowed for each dress purchased.
15. Refunds will be processed within 7-10 Business days after we receive your return
16. Original Shipping charges are non refundable
17. Store Credit can not be transferred to another person or account
18. Store Credit may not be purchased and is only provided when purchased items have been returned and you have selected "Store Credit" as the refund method

## COLOURS &amp; MATERIALS

Fame &amp; Partners makes custom, on-demand dresses and as part of our bespoke customised process we often use small runs of special materials and dip dye some fabrics to ensure every dress is unique to every customer. We understand you want to know what your special dress should look like when it arrives at your door, so we sometimes use digital colour replication on our Web site to show all the different colour variations you can select from. Therefore, while we're doing our best to show colours and material variations digitally across all different computer and mobile screens our customers use, we want you to understand that the digital colours and materials as they appear and are described on this Web site may not perfectly match the colours and materials of our actual garments and some slight variations may occur.

## GST

Fame &amp; Partners is required by law to collect GST on all orders shipped to customers in Australia. The appropriate charges will be added to your merchandise total and displayed on your final order confirmation. No GST is charged on International Orders.

## YOUR USE OF THIS SITE

Your use of this Site for any illegal or unauthorized purpose is expressly prohibited. In consideration of your use of this Site, you agree to provide true and accurate information about yourself when creating an Account, and update your Account from time to time to keep it accurate. If you provide, or the Company has reasonable grounds to suspect that you have provided, information that is untrue, inaccurate, not current or incomplete, the Company has the right to suspend and refuse any and all current or future access by you to this Site or any portion thereof. Furthermore, if the Company has any reason to believe that you may be creating fraudulent accounts or engaging in any deceptive behaviour while using this Site, the Company may suspend and refuse any and all current or future access by you to this Site or any portion thereof and may also refuse to honour any credits or other earned benefits.

The Company reserves the right at any time to modify or discontinue, temporarily or permanently, this Site or any part thereof with or without notice. You agree that the Company shall not be liable to you or to any third party for any modification, suspension or discontinuance of this Site or any part thereof. The following sections shall survive any termination of these Terms: "Copyright," "Indemnification," "Disclaimer of Warranties; Limitation of Liability," "Disputes and Dispute Resolution" (including all subsections) and "General."

This Site may be linked to other Web sites. You acknowledge and agree that the Company is not responsible for the availability of such external Web sites, and does not endorse and is not responsible or liable for any content, advertising, products and/or other materials on or available from such Web sites. You further acknowledge and agree that the Company shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with use of or reliance on any such content, goods or services available on or through any such Web site.

By connecting to Fame &amp; Partners with a third-party service (e.g., Facebook or Twitter), you give us permission to access and use your information from that service as permitted by that service, and to store your log-in credentials for that service. For more information on the types of information we collect from these third-party services, please read our Privacy Policy.

If you utilize your Facebook account to access and use the social features on this Site, you can choose whether or not you wish to share content or information related to your Account on Facebook. You agree that this Site is not responsible for any content or information related to your Account once it is shared and posted on Facebook. If you use this Site and its social features, you agree to respect other users of this Site in your interactions with them. Company reserves the right, in its absolute discretion, to disable your account if it believes that you are violating any term or condition set forth herein.

Prices, descriptions and availability of products on this Site are subject to change without notice. Errors may be corrected when discovered, and the Company reserves the right to revoke any stated offer in order to correct any errors or inaccuracies. The Company does not guarantee that information displayed on the Site is 100% accurate.

## PROMOTIONAL DISCOUNT CODES

* We may from time to time offer promotional discount codes which may apply in respect of any, or certain specified purchases made throughout this Website.
* The conditions of use relating to any discount code will be specified at the time of issue.
* These T&amp;Cs relate to all Fame &amp; Partners promotions and discount codes (unless otherwise stated).
* Limited to one promotional code per order
* Limited to orders of $100 and over
* Limited to full price items only
* Cannot be used in conjunction with any other promotional offer
* Cannot be used after an order has already been placed
* No one promotional discount code or voucher can be used in conjunction with any other discount code or voucher, on the Fame &amp; Partners website, unless explicitly stated otherwise by an authorised representative at Fame &amp; Partners
* Vouchers and promotional codes are not redeemable for cash
* Vouchers and promotional codes are not transferrable
* Vouchers and promotional codes cannot be used against custom dress orders
* Vouchers and promotional codes are valid only for 2 weeks from date of receipt
* The decision of whether or not to honour a voucher or a promotional code is at Fame &amp; Partner's sole discretion. All decisions are final and binding.

## GIFT WITH PURCHASE

* We may from time to time promote a free gift with purchase.
* The free gift with purchase promotion applies only to new orders placed on our Site and fully paid after the date the free gift with purchase promotion is made available on the Site.
* You are limited to one free gift per order irrespective of the number of items purchased in your order.
* The free gift with purchase is available only while stocks last.
* We are under no obligation to advise you of the remaining number of free gifts available at any time.
* You may be sent an alternative colour choice in your free gift due to the unavailability of your original colour choice.
* The free gift with purchase cannot be redeemed, refunded or exchanged for cash or any other discount.
* We reserve the right to withdraw, modify, vary or terminate any free gift with purchase promotion at any time for any reason.
* The free gift will be dispatched separately. Please allow 3 weeks for delivery.

## COPYRIGHT

Unless otherwise indicated, this Site and all content contained therein, including but not limited to text, photographs, images, icons, graphics, trademarks, trade names, logos and software ("Content"), is owned by the Company and protected by applicable law. You agree not to copy, publish, use, display, transmit, modify, transfer, sell, reformat, distribute, create derivative works from, or in any way exploit the Content without the Company's prior written approval. In addition, any mechanized or systematic processes for harvesting information from this Site for any purpose is prohibited. Nothing contained in or on this Site should be construed as granting any license or right, by implication or otherwise, to use any of the Content at any time.

Copyright 2014 Fame &amp; Partners Pty Ltd. All rights reserved.

All celebrity images on www.fameandpartners.com are courtesy of Shutterstock, Google Images and Tumblr.

## ACCOUNT CONFIDENTIALITY AND ACCESS

You are solely responsible for maintaining the confidentiality of your Account, all activities occurring under your Account and all access to and use of the Site by anyone using your Account, whether or not such activities and access are actually authorized by you, including but not limited to all communications, transactions and obligations. The Company shall not be liable or responsible for any loss or damage arising from any unauthorized use, access or any other breach of security of your Account, including but not limited to your member sign-in password and email address. You acknowledge and accept that your use of the Site is in compliance with these Terms. You further acknowledge and accept that the Company shall have no obligation to investigate the authorization or source of any Account activity, including purchase activity following a proper log-in to the Site, which is defined as a matching and current member sign-in and user password. You shall notify the Company immediately of any unauthorized access to your Account or any other unauthorized use of the Site.

You agree that the Company may, without prior notice, immediately terminate, limit your access to or suspend your Account based on any of the following: (a) breach or violation of these Terms; (b) upon request by law enforcement; (c) unforeseeable technical or security issues or problems; (d) extended periods of inactivity; or (e) fraudulent, deceptive or illegal activity, or any other activity which the Company believes is harmful to this Site or its business interests. You agree that any termination, limitation of access and/or suspension shall be made in the Company's sole discretion and that the Company shall not be liable to you or any third party for the termination, limitation of access and/or suspension of your Account.

## INDEMNIFICATION

You agree to indemnify and hold the Company and its subsidiaries, affiliates, officers, agents and employees harmless from any and all liabilities, claims, demands, actions, suits, losses, obligations, judgments, proceedings, damages, expenses and costs (including reasonable attorneys' fees), based upon, arising from or related to (a) information or content submitted, transmitted or otherwise made available on or through this Site by you or any other person accessing the Site using your Account; (b) the use of, or connection to, this Site by you or any other person accessing the Site using your Account (including negligent or wrongful conduct); or (c) your breach or attempted breach of these Terms.

## DISCLAIMER OF WARRANTIES; LIMITATION OF LIABILITY

YOUR USE OF THIS SITE IS AT YOUR SOLE RISK. THIS SITE AND THE PRODUCTS AND SERVICES OFFERED ON THE SITE ARE PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS AND WITHOUT WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED.

TO THE FULLEST EXTENT PERMITTED BY APPLICABLE LAW, THE COMPANY DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.

THE COMPANY MAKES NO REPRESENTATIONS OR WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, THAT THE OPERATION OF THIS SITE WILL BE UNINTERRUPTED OR ERROR-FREE, THAT ANY DEFECTS WILL BE CORRECTED, OR THAT THE SITE OR THE SERVER THAT MAKES THE SITE AVAILABLE ARE FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS, OR AS TO THE INFORMATION, CONTENT, MATERIALS, PRODUCTS OR SERVICES INCLUDED ON OR OTHERWISE MADE AVAILABLE TO YOU THROUGH THIS SITE, IN TERMS OF THEIR CORRECTNESS, ACCURACY, ADEQUACY, USEFULNESS, TIMELINESS, RELIABILITY OR OTHERWISE, UNLESS OTHERWISE SPECIFIED IN WRITING.

THE COMPANY SHALL NOT BE LIABLE FOR ANY DAMAGES OF ANY KIND ARISING FROM THE USE OF, OR THE INABILITY TO USE, THIS SITE OR FROM ANY INFORMATION, CONTENT, MATERIALS, PRODUCTS OR SERVICES INCLUDED ON OR OTHERWISE MADE AVAILABLE TO YOU THROUGH THIS SITE, INCLUDING, BUT NOT LIMITED TO DIRECT, INDIRECT, INCIDENTAL, SPECIAL, PUNITIVE AND CONSEQUENTIAL DAMAGES, EVEN IF THE COMPANY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

CERTAIN LAWS MAY NOT ALLOW LIMITATIONS ON IMPLIED WARRANTIES OR THE EXCLUSION OR LIMITATION OF CERTAIN DAMAGES. IF THESE LAWS APPLY TO YOU, SOME OR ALL OF THE ABOVE DISCLAIMERS, EXCLUSIONS OR LIMITATIONS MAY NOT APPLY TO YOU AND YOU MAY HAVE ADDITIONAL RIGHTS.

IF YOU ARE DISSATISFIED WITH ANY PORTION OF THIS SITE, OR WITH ANY OF THESE TERMS OF USE, YOUR SOLE AND EXCLUSIVE REMEDY IS TO DISCONTINUE USE OF THIS SITE. IF A PRODUCT OFFERED ON THIS SITE IS NOT AS DESCRIBED, YOUR SOLE REMEDY IS TO RETURN IT IN ACCORDANCE WITH THE RETURN POLICY SET FORTH IN DETAIL ON THIS SITE.

## DISPUTES AND DISPUTE RESOLUTION

### GUARANTEE AND COMPLAINTS MANAGEMENT

The Company shall perform its obligations under these Terms and Conditions with reasonable skills and care.

The Company places great value on customer satisfaction. You may contact us at any time using the contact details provided on the Site. We will attempt to address your concerns as soon as reasonably possible and will make our best endeavours to contact you on receipt of any relevant enquiry or complaint. In the event of a complaint it will help us if you can describe the object of your complaint as accurately as possible and, where applicable, send us copies of the Order or at least the order number that we assign you in the Acknowledgement or Confirmation of Order. Should you not have received any reaction from us within five Business Days, please make further enquiries. In rare cases your emails may be caught up in our spam filters or not reach us, or correspondence that we send to you may otherwise not have reached you.

### FORCE MAJEUR (Circumstances beyond The Company's control)

The Company shall not be liable to you for any breach, hindrance or delay in the performance of these Terms attributable to any cause beyond our reasonable control, including without limitation any natural disaster and unavoidable incident, actions of third parties (including without limitation hackers, suppliers, governments, quasi-governmental, supra-national or local authorities), insurrection, riot, civil commotion, war, hostilities, warlike operations, national emergencies, terrorism, piracy, arrests, restraints or detainments of any competent authority, strikes or combinations or lock-out of workmen, epidemic, fire, explosion, storm, flood, drought, weather conditions, earthquake, natural disaster, accident, mechanical breakdown, third party software, failure or problems with public utility supplies (including electrical, telecoms or Internet failure), shortage of or inability to obtain supplies, materials, equipment or transportation ("Event of Force Majeure"), regardless of whether the circumstances in question could have been foreseen.

1. Either you or we may terminate your order of a product or products forthwith by written notice to the other in the event that the Event of Force Majeure lasts for a period of two business days or more, in which event neither you nor we shall be liable to the other by reason of such termination (other than for the refund of a product already paid for by you and not delivered).
2. If we have contracted to provide identical or similar products to more than one customer and are prevented from fully meeting our obligations to you by reason of an event of Force Majeure, we may decide at our absolute discretion which contracts we will perform and to what extent.

## NOTICES

Any notice shall be in writing and may be served by personal delivery or by pre-paid or recorded delivery letter or by email addressed to the relevant party at the address or email address of the relevant party last known to the other.

Any notice given by post shall be deemed to have been served two Business Days after the same has been posted if the postage and recipient address is in the Australia and ten Business Days after the same has been posted if the postage and/or recipient address is International. Any notice given by email shall be deemed to have been served when the email has been proved to be received by the recipient's server. In proving such service it shall be sufficient to prove that the letter or email was properly addressed and, as the case may be, posted as a prepaid or recorded delivery letter or despatched or a delivery report received.

## GOVERNING LAW

Use of this Site, membership in the Fame &amp; Partners Membership Program, any purchases made through this Site, and any controversy, claim or dispute arising out of or relating in any way to your use of the Site, your membership in or purchases through the Site, Fame &amp; Partners Membership Program and/or your Account, or products purchased through the Site shall be governed by the laws of New South Wales, Australia.

Both you and the Company waive the right to bring any controversy, claim or dispute arising out of or relating in any way to your use of the Site, your membership in or purchases through the Fame &amp; Partners Membership Program and/or your Account, or products purchased through the Site as a class, consolidated, representative, collective, or private attorney general action, or to participate in a class, consolidated, representative, collective, or private attorney general action regarding any such claim brought by anyone else.

## FORUM SELECTION/JURISDICTION

Jurisdiction and venue for any dispute shall be in New South Wales, Australia. Each party submits to personal jurisdiction and venue in that forum for any and all purposes.

## AGREEMENT TO PRE-ARBITRATION NOTIFICATION

These Terms provide for final, binding arbitration of all disputed claims (discussed immediately below). The Company and you agree, however, that it would be advantageous to discuss and hopefully resolve any disputes before any proceedings or any other proceedings authorized herein are initiated. In the event of a dispute, the claimant whether you or the Company shall send a letter to the other side briefly summarizing the claim and the request for relief. If the Company is the claimant, the letter shall be sent, via email, to the email account listed in your Account. If you are the claimant, the letter shall be sent to Fame &amp; Partners Pty Ltd, Level 1, Studio 10, 140-144 CLEVELAND STREET, CHIPPENDALE NSW 2008. If the dispute is not resolved within 60 days after the letter is sent, the claimant may proceed to initiate arbitration proceedings or any other proceedings authorized herein.

## AGREEMENT TO ARBITRATE CLAIMS

Except to the limited extent noted below, use of this Site, membership in the Fame &amp; Partners Membership Program, any purchases made through this Site, and any controversy, claim or dispute arising out of or relating in any way to your use of the Site, your membership in or purchases through the Fame &amp; Partners Membership Program, or products and services purchased through the Site shall be resolved by final and binding arbitration.

The arbitration shall take place in Sydney, New South Wales, Australia in accordance with the Australian Consumer Law 2011 and will be run by a regulator provided by the State, in accordance with the governing guidance principles.

## GENERAL

These Terms and the Company's Privacy Policy constitute the entire agreement between you and the Company and govern your use of this Site and supersede any prior version of these Terms between you and the Company with respect to this Site.

The failure of the Company to exercise or enforce any right or provision of these Terms shall not constitute a waiver or relinquishment to any extent of the Company's right to assert or rely upon any such provision or right in that or any other instance, and the same shall be and remain in full force and effect. If any provision of these Terms is found by a court of competent jurisdiction, statute, rule or otherwise to be invalid, the parties nevertheless agree that the remaining provisions shall not be affected thereby and shall continue in full force and effect, and such provision may be modified or severed from these Terms to the extent necessary to make such provision enforceable and consistent with the remainder of these Terms.

Updated May 2015

* * *

## WIN A DRESS FOR YOU AND YOUR BESTIE COMPETITION TERMS AND CONDITIONS

The promoter is Fame &amp; Partners Pty Ltd ABN 83 162 501 064 (Fame) whose registered office is at Level 1, Studio 10, 140 – 144 Cleveland St Chippendale New South Wales 2008 Australia, . Fame will facilitate the fulfilment and management of the promotion and any associated prizes.

Entry is open internationally to anyone aged 16 years or older. Directors, officers and employees of Fame and any associated companies and agencies as well as the immediate families of each of these parties are not eligible to participate in the promotion.

The promotion begins at 5:00pm AEST 23 October 2015 and closes 5:00pm AEST 30 October 2015

To be eligible to win the prize you must:
(a) Regram the official Fame promotion entry image (the Image) that has been posted to the official Fame Instagram account;
(b) Follow the @fameandpartners account:
(c) Tag each entry with #famebestie and @fameandpartners;
(d) All eligible entries must include the answer to this question as the caption in 25 words or less "Which Fame and Partners dress do you need in your life and why?"
(e) Your Instagram account must be set to "public" for the duration of this promotion;
(f) Your entry must be your own original work; and
(g) You can enter as many times as you like, but you must supply a new caption for each entry.

The best entry will be judged by Fame in its absolute discretion. Fame's decision is final and no correspondence will be entered into. The winner will be announced on 2 November 2015 and will be notified via their Instagram entry. They must then provide Fame with their contact e-mail address within 48 hours of notification. Fame accepts no responsibility for unread, undelivered or incorrectly provided email or telephone information.

The winners prize will be 2 dresses redeemable online at http://www.fameandpartners.com through correspondence with Fame via e-mail.

The runner-up prizes for the next 100 entrants will be a 30% Off E-Gift Card. Runners-up will receive their personalised discount code through an Instagram Direct Message. This E-Gift Card will be valid until 31 December 2015 and is redeemable online at http://www.fameandpartners.com.

Prizes cannot be transferred, exchanged or redeemed for cash.

Fame reserves the right to re-judge the competition in the event the selected winner is unable to satisfy these terms and conditions,forfeits their prize or does not claimtheir prize. If a prize is forfeited or unclaimed as of 2 November 2015, Fame will announce a new winner at 2:00pm AEST at its registered offices..

Fame (and each of its related bodies corporate, their officers, employees and agents) will not be liable for any loss, damage, or personal injury (including but not limited to indirect or consequential loss) whatsoever that is suffered or sustained in connection with this promotion, the promotion of this promotion, the receipt or use of the prizes, except for any liability which cannot be excluded by law. Fame is not responsible for any failure or technical malfunction of any telephone network or lines, computer online systems, or providers, computer equipment, servers, or providers, computer equipment, software, technical failure or traffic congestion on the internet or at any website, or any combination thereof, including but not limited to, any injury or damage you or any other person may suffer related to or resulting from participation in or downloading any materials related to this promotion. In the event of war, terrorism, state of emergency or disaster Fame reserves the right (subject to any written directions under applicable law) to cancel, terminate, modify or suspend this promotion.

By submitting your entry, you grant Fame the right and permission (except where prohibited by law) to copy, reproduce, encode, store, transmit, publish, post, broadcast, display, adapt, exhibit and/or otherwise use or reuse (without limitation as to when, where, or the number of times) the Image and your name; Instagram name; image; voice; persona; sobriquet; likeness; statements; and biographical material on Fame's website located at http://www.fameandpartners.com , Fame's Instagram account located at http://www.instagram.com/fameandpartners/ and/or the Fame Facebook page located at http://www.facebook.com/fameandpartners for purpose of administering and advertising the promotion, foregoing without additional review, compensation, notice to, or approval from you or any other party, unless prohibited by law. By submitting an Instagram photo with the designated hashtag, you consent to the collection, use, and disclosure of the information described herein.

* * *

## MOST WANTED - 20% off sale

1) Offer not valid on customisations, custom colours or express making fees. - Bring on the night collection styles are excluded from offer.

2) The discount will only apply once the code PREGAME20 has been entered by the customer.

3) Offer valid on recommended colours only.

4) Offer valid 23rd - 26th November 2015 11.59pm AEDT only.

5) Orders to AU, US & UK incur a $11.70 USD dispatch fee. All other countries incur a $30 USD shipping fee. Shipping & handling timing approximately 7-10 days on all orders.

6) A $14.95 restocking fee will be applied for each dress returned.

7) Fame and Partners may vary, or cancel this promotion at any time without notice.

8) This promotion is subject to the general terms and conditions of the website.

[1]: /contact/new

EOS
    page.translations.create!(:locale => 'en-US', :title => 'Terms and Conditions', :meta_description => 'Terms and Conditions', :heading => 'Terms and Conditions', :description => description)
  end

  def down
    Revolution::Page.where(:path => '/terms').delete_all
  end
end
