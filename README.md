An important element of portfolio theory is rebalancing your portfolio on a regular basis.
This is often overlooked (especially by me) so I decided to get rid of some of the pain
points by creating an app that does the heavy lifting. This app will 1) login to Vanguard,
2) download a csv of all your investments and 3) calculate the amount of your investments
that you should buy or sell. This is determined by comparing the portfolios you determine
in the user_data directory and the desired investment composition. The app will output
what you should buy or sell to bring your investment portfolio back in line. It does
not buy or sell your investments automatically. I wasn't comfortable letting a program
do that for me.

Start by cloning the project to your computer.
Then type bundle install.
You must fill out all the samples in the user_data directory and remove '_sample' from the file name.
You must add the `tmp` and `archive` directories to the `data` directory
To run, type ruby bot.rb.
Type 'bundle exec rspec' to run the tests.
