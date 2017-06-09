 # Transaction Cleaner
 
 ### Description
 This lightweight program was designed for:
 * The security-concious (ok, paranoid)
 * The accountants 
 * The programmers
 * The DIY-ers
 
 There is plenty of other (better) software one can use to manage their personal finances. 
 However, in attempts to make their products accessible to the masses, most (all?) of the providers
 of these personal financial management solutions have sacrificed the flexibility needed for 
 all of the diverse situations each person may encounter. 
 
 Many of us are probably familiar with [Mint](http://www.mint.com "Mint"), which is really remarkable
 software that goes out and gets all your financial data and aggregates it in a meaningful way.
 However, to make this work, you have to give Mint the login information to ALL of your financial
 relationships. This makes them a huge target for attacks. In addition, it means any time one of 
 the websites of one of these financial institutions changes, Mint may be temporarily broken and
 you have no good way to get your financial data into Mint's system, leaving you in the dark as
 to your current financial position. Finally, even if Mint never gets hacked and you're ok with 
 stuff not working for periods of time on occasion, you can't create your own custom graphs or tables
 you can't dig into the data the way some of us nerds might to answer a question... Like what if you
 want to know how often you go out to eat Mon-Thurs? No way to get an answer from Mint. 
 
 Thus Transaction Cleaner. This tool will allow you (when it's finished) to drag and drop CSV files
 which will be parsed according to the rules YOU set up. Based on those rules, a new, "clean" CSV
 will be produced containing all the data that could be gleaned from the CSVs you dragged and dropped.
 In addition, you'll get a handy Excel file that will take these CSVs and turn them into meaningful
 financial information. If you want to customize from there... The world is your oyster.
 
 ### Installation
 
 Currently, there is no interface for the code. However it does "work." If you're a programmer (particularly
 a rubyist) you can probably figure it out. Basically you'll need to clone the project, then install ruby if
 it's not already installed. After that, you'll need bundler, so paste this into your command line:
 
 ```ruby
  gem install bundler
  ```
  cd to the correct folder where you cloned the project and:
  ```ruby
  bundle install
```
Finally to run the project:

```ruby
ruby program_flow.rb
```

Right now you'll need to play with some variables to get it to do anything useful. You'll also need to
edit the rules in the dev.db database. Soon, I'll have a command line interface you can use while I'm 
finishing the front end drag and drop functionality. If you want to get involved, shoot me an email:

```
shane.ryan.williamson@gmail.com
```