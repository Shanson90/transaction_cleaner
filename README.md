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
 which will be parsed according to the rules **YOU** set up. Based on those rules, a new, "clean" CSV
 will be produced containing all the data that could be gleaned from the CSVs you dragged and dropped.
 In addition, you'll get a handy Excel file that will take these CSVs and turn them into meaningful
 financial information. If you want to customize from there... The world is your oyster.
 
 ### Installation
 
 If you're a programmer (particularly a rubyist) you can probably figure it out. Basically you'll need to clone the 
 project, then install ruby if it's not already installed. After that, you'll need bundler, so paste this into your 
 command line:
 
 ```ruby
  gem install bundler
  ```
  cd to the correct folder where you cloned the project and:
  ```ruby
  bundle install
```
Finally to run the project:

```ruby
ruby run_cli.rb
```

I haven't built any kind of front end or UI for this thing yet, because I actually just want to 
start using it as soon as I can. However I have hacked together a little command-line interface (CLI)
 that works well enough for now. I'm still fleshing out some of my options for how to make this work
 with **any** CSV file from any financial institution with little or zero manual work for the user, 
 but it works great with my credit card transactions from Citi. Manipulating rules can be done 
 through the CLI as well, and you're welcome to create your own database of rules, which is the idea, but
 I've committed my whole DB in the project so you can see what rules should look like and how they work.
 
 If you want to get involved, shoot me an email:

```
shane.ryan.williamson@gmail.com
```