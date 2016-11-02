class CreateRevolutionPagesForStaticPages < ActiveRecord::Migration
  private def csv_content
    <<-CSV
title;template_path;path;us_description;au_description
New Size Guide;/statics/size_guide;/size-guide;Fame and Partners guarantees a perfect fit for bodies of all shapes and sizes. Use our size chart to determine which size will fit and flatter your body.;Fame and Partners guarantees a perfect fit for bodies of all shapes and sizes. Use our size chart to determine which size will fit and flatter your body.
Why Us;/statics/why_us;/why-us;Why shop with Fame and Partners? Our clothing is customizable, made-to-order, ethically produced, and guaranteed to fit and flatter. Find out more.;Why shop with Fame and Partners? Our clothing is customisable, made-to-order, ethically produced, and guaranteed to fit and flatter. Find out more.
Our Growth Plan;/statics/growth_plan;/growth-plan;Fame and Partners has successfully navigated the path from Australian start-up to US-based early stage growth company. Find out how we plan to keep expanding our business.;Fame and Partners has successfully navigated the path from Australian start-up to US-based early stage growth company. Find out how we plan to keep expanding our business.
Contact;/products/collections/show;/contact;Contact the Fame and Partners customer service department or find the answers to our Frequently Asked Questions.;Contact the Fame and Partners customer service department or find the answers to our Frequently Asked Questions.
The Freshly Picked Collection;/lookbook/show;/lookbook/the-freshly-picked-collection;Shop Fame and Partners' cotton dresses, jumpsuits, and two-piece sets, perfect for warmer weather. Every piece is customizable and made-to-order, just for you.;Shop Fame and Partners' cotton dresses, jumpsuits, and two-piece sets, perfect for warmer weather. Every piece is customisable and made-to-order, just for you.
Privacy;/statics/ecom_privacy;/privacy;Everything you want to know about Fame and Partners' privacy policy.;Everything you want to know about Fame and Partners' privacy policy.
From our CEO;/statics/from_our_ceo;/from-our-ceo;A monthly update from Fame and Partners' CEO, Nyree Corby, on what's new in the world of Fame.;A monthly update from Fame and Partners' CEO, Nyree Corby, on what's new in the world of Fame.
Syle Session;/products/collections/show;/styling-session;Fame and Partners offers FREE one-on-one styling sessions with a wardrobe stylist via phone call, text, online chat, video message, and even in-person. Book your styling appointment today!;Fame and Partners offers FREE one-on-one styling sessions with a wardrobe stylist via phone call, text, online chat, and video message. Book your styling appointment today!
FAQs;/statics/faqs;/faqs;Answers to all of Fame and Partners' Frequently Asked Questions. Find out about our returns process, size chart, and more.;Answers to all of Fame and Partners' Frequently Asked Questions. Find out about our returns process, size chart, and more.
Wedding Consultation;/products/collections/show;/wedding-consultation;Fame and Partners offers FREE one-on-one wedding consultations for the bride and entire bridal partyvia phone call, text, online chat, video message, and even in-person. Book your styling appointment with our wardrobe stylist today!;Fame and Partners offers FREE one-on-one wedding consultations for the bride and entire bridal partyvia phone call, text, online chat, video message, and even in-person. Book your styling appointment with our wardrobe stylist today!
Sarah Ellen - Dance Hall Days;/lookbook/sarah_ellen;/sarah-ellen;Shop Sarah Ellen's favorite dresses and two piece sets from Fame and Partners, all customizable to suit your style and made-to-order, just for you.;Shop Sarah Ellen's favorite dresses and two piece sets from Fame and Partners, all customisable to suit your style and made-to-order, just for you.
Bring on the Night;/lookbook/bring_on_the_night;/lookbook/bring-on-the-night;Shop Fame and Partners' Bring On The Night Collection of customizable cocktail dresses, mini dresses, wrap dresses, maxi dresses, and two piece sets–all made-to-order, just for you.;Shop Fame and Partners' Bring On The Night Collection of customisable cocktail dresses, mini dresses, wrap dresses, maxi dresses, and two piece sets–all made-to-order, just for you.
Little Black Dress;/products/collections/show;/dresses/little-black-dress;Find the perfect Little Black Dress from Fame and Partners–every dress is guaranteed to fit and flatter. Each LBD is customizable to suit your style and made-to-order, just for you.;Find the perfect Little Black Dress from Fame and Partners–every dress is guaranteed to fit and flatter. Each LBD is customisable to suit your style and made-to-order, just for you.
Shop Instagram;/landing_pages/shop-social;/shop-social;Shop every dress, skirt, jumpsuit, and two piece set featured on Fame and Partners' Instagram page–all customizable and made-to-order.;Shop every dress, skirt, jumpsuit, and two piece set featured on Fame and Partners' Instagram page–all customisable and made-to-order.
Terms & Conditions;/statics/ecom_terms;/terms;Everything you want to know about Fame and Partners' Terms & Conditions.;Everything you want to know about Fame and Partners' Terms & Conditions.
Sleeves;/products/collections/show;/dresses/long-sleeve;Shop long-sleeve dresses from Fame and Partners, including long sleeve gowns, long sleeve cocktail dresses, and long sleeve mini dresses–all customizable and made-to-order.;Shop long-sleeve dresses from Fame and Partners, including long sleeve gowns, long sleeve cocktail dresses, and long sleeve mini dresses–all customisable and made-to-order.
This Modern Romance;/products/collections/show;/lookbook/this-modern-romance;Shop Fame and Partners' This Modern Romance Collection of romantic wrap dresses, long gowns, printed dresses, and two-piece sets–all customizable and made-to-order.;Shop Fame and Partners' This Modern Romance Collection of romantic wrap dresses, long gowns, printed dresses, and two-piece sets–all customisable and made-to-order.
Just The Girls;/products/collections/show;/lookbook/just-the-girls;Shop Fame and Partners' Just The Girls Collection, full of customizable, made-to-order prom dresses and gowns.;Shop Fame and Partners' Just The Girls Collection, full of customisable, made-to-order formal dresses and gowns.
Make A Statement;/products/collections/show;/lookbook/make-a-statement;Bambi Northwood-Blyth models Fame and Partners' Make A Statement collection of statement dresses, embellished cocktail dresses, and bright jumpsuits–all customizable and made-to-order.;Bambi Northwood-Blyth models Fame and Partners' Make A Statement collection of statement dresses, embellished cocktail dresses, and bright jumpsuits–all customisable and made-to-order.
Photo Finish;/products/collections/show;/lookbook/photo-finish;Shop Fame and Partners' Photo Finish lookbook of customizable cocktail dresses, lace jumpsuits, and more.;Shop Fame and Partners' Photo Finish lookbook of customisable cocktail dresses, lace jumpsuits, and more.
Print Dresses;/products/collections/show;/dresses/print;Printed maxis, printed minis, and printed cocktail dresses in abstract, floral, feathered, and bohemian prints from Fame and Partners. Each piece is customizable and made-to-order, just for you.;Printed maxis, printed minis, and printed cocktail dresses in abstract, floral, feathered, and bohemian prints from Fame and Partners. Each piece is customisable and made-to-order, just for you.
The Ruffled Up Collection;/products/collections/show;/lookbook/the-ruffled-up-collection;Ruffled dresses, ruffled skirts, and ruffled tops that are customizable to suit your style and guaranteed to fit and flatter.;Ruffled dresses, ruffled skirts, and ruffled tops that are customisable to suit your style and guaranteed to fit and flatter.
Partners In Crime;/products/collections/show;/partners-in-crime;We reveal the Fame and Partners' #PartnersInCrime contest winners as well as the full, customizable Partners In Crime collection.;We reveal the Fame and Partners' #PartnersInCrime contest winners as well as the full, customisable Partners In Crime collection.
New This Week;/products/collections/show;/dresses/new-this-week;Shop new styles at Fame and Partners! Scroll through our latest collection of dresses, skirts, jumpsuits, and two piece sets–all customizable and made-to-order.;Shop new styles at Fame and Partners! Scroll through our latest collection of dresses, skirts, jumpsuits, and two piece sets–all customisable and made-to-order.
    CSV
  end

  def up
    csv_file = CSV.new(csv_content, headers: :first_row, col_sep: ';')

    while (row = csv_file.readline)
      unless Revolution::Page.exists?(path: row['path'])
        page = Revolution::Page.create!(
          path:          row['path'],
          template_path: row['template_path'],
          publish_from:  2.day.ago
        )
        page.translations.create!(locale: 'en-US', title: row['title'], meta_description: row['us_description'])
        page.translations.create!(locale: 'en-AU', title: row['title'], meta_description: row['au_description'])
      end
    end
  end

  def down
    # NOOP
  end
end
