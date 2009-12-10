# Cocoa Boutique
## A store that specializes in elite and fashionable software

### Intro

Cocoa Boutique is an open source framework that lets you add in-app purchase to your Cocoa applications. Replacement for Kagi, eSellerate, Golden Braeburn etc

### Process

After taking your customers details in your own application, they are transmitted to your web server which calls PayPal's Website Payment Pro APIs.  If the transaction is successful, it is recorded in your database and an AquaticPrime dictionary is transmitted back to your application on the customer's computer.

All configuration and response handling is setup by implementing the Cocoa Boutique delegate protocol.

### Requirements

* PHP 5 with curl, bcmath
* MySQL 4
* AquaticPrime (included server-side)
* PayPal Website Payments Pro

### Communication

Google Group - [http://groups.google.com/group/cocoa-boutique](http://groups.google.com/group/cocoa-boutique)

Twitter - [@cocoaboutique](http://twitter.com/cocoaboutique)

### Contributors

* Fraser Hess
* Kevin Hoctor
* Tom Harrington

### Needs

* Put it in your app
* Report/fix issues
* Contribute ideas
* Write docs
* Blog/podcast about it
* Record screencasts
* Draw better graphics
* Send money
* Send ice cream
