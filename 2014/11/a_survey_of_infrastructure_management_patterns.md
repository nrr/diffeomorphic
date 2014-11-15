# A survey of infrastructure management patterns

Write an introduction here. Bring up our agenda for this particular
piece of rambling, present a thesis, and provide some background.

I've had root on lots of systems in my lifetime so far; as of this
writing, I would estimate that I have had superuser access to a number
of machines in the low to mid hundred thousands. That's a lot of
machines.

To add more complexity to the situation, that experience is drawn from
pools of both strictly homogeneous workloads (e.g., compute clusters for
scientific research) and wildly heterogeneous workloads (e.g., those of
a hosting provider with a lot of customers).

This has led me down a road of forming perspectives and opinions on how
these kinds of things should be run. While I do discuss warehouse-scale
at the 10^6 and 10^7 orders of magnitude, I have not yet had root on any
such systems. Though, rumor has it (seeing as Hözle himself is listed as
a coauthor on the authoritative book on the subject) that Google
operates at that kind of scale.

That all said, I hope to touch on at least the following with each jump
in order of magnitude:

* the technical challenges in maintaining the configuration of that
number of machines;
* the social and organizational challenges in implementing process and
procedure around that many machines;
* a good strategy for breaking down the problem into a few component
parts to make it easier for our lizard brains to understand them;
* some tools that I've used in the past at this scale; and
* some tools that I would consider using, along with their caveats.

# Thinking small: 10^0 and 10^1

Everyone has to start somewhere, and unless you have an immediate market
need to have anything larger (like, say, being a boutique hosting
provider for several customers), this is likely where you will start if
you're building from scratch.

In cases like this, I've tended to err on the side of smaller ad hoc
shell scripts and wiki tools. In the past, I used CVS and (the WikiBase
software)[http://www.c2.com/cgi/wiki?WikiBase] to maintain this kind of
thing. These days, I'd probably just use (the Fossil
SCM)[http://www.fossil-scm.org/index.html/doc/tip/www/index.wiki] for
everything; it's a distributed SCM, wiki, and ticketing system all in
one.

On the note of ticketing system, it's also a good idea to set one up for
work intake and tracking. I've had good success with Best Practical's
RT, and in my capacity at Contegix doing work for Atlassian, I naturally
had a lot of exposure to JIRA. They're both good tools, but they come
with a lot of ceremony out of the box. Rip as much of that out as
possible.

Speaking to the notion of customer service, try to distill your work
intake to the point where support requests are literally an email to
support@. If you need to differentiate customers, either do it by email
domain (if you can) or with a unique number that identifies the
overarching support account.

# Growing up: 10^2 and 10^3

# Moving out of mom's basement: 10^4

# Making a difference as a 20-something free spirit: 10^5

# Working at warehouse scale: 10^6 and 10^7

# Commonalities and conclusions

Write a conclusion here. Say a few words about what we just discussed,
and tie it all together with a theme or something.
