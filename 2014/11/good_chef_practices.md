# Good Chef practices

In case you're wondering why I chose the word "good" instead of "best,"
just consider that "best" implies that your opinions are the only ones
worth listening to, and that every other opinion is somehow some notion
of "wrong." I disagree quite strongly with that mentality.

In fact, read the title of this document as "good Chef ideas," or
perhaps, you could read it as "starter Chef opinions." The point is to
illustrate a workflow, strategy, and code style that tends to work for
large, heterogeneous, disparate environments. The hope is that the
content contained herein is useful for all environments; however, I will
cheerfully acknowledge that not one size fits all. That right there is,
after all, a core tenet of the Fundamental Systems Truths.

I also chose the base form of the adjective "good" instead of the
comparative "better" to imply that this could very well be a baseline
set of practices that anyone could adopt to start. One of the difficult
parts of Chef is that, as a product, it isn't quite opinionated enough,
and unless you invest a _lot_ of time in keeping up with the community,
looking at what everyone is doing, asking questions, the framework will
inundate you up to your eyeballs in directions to take. This definitely
does show Chef's roots as a Perl app written using Catalyst. While we do
have much to owe to Chef's flexibility and the pragmatism of Adam Jacob,
it helps to have some well-informed opinions out of the box to help
newcomers adopt the technology.

That all said, there will also be a part of this document that addresses
part of the wetware concerns, namely how to adopt a change-embracing
instead of a change-averse culture. I intend to bust a number of the
myths that operations cannot work with some degree of agility in larger
environments, at least not when it comes to making it work well. The
only real impediment is having executives suspend belief for a moment
while their good engineers do what they're good at and help lead
everyone along to a path of prosperity.

Nevertheless, I particularly like the flexibility that Chef provides,
and it is quite a nice tool for implementing systems automation. The
only failing is that it is a vast and expansive framework within which
to work, very much like C++'s Standard Template Library. You needn't use
every feature; instead, you need to consider very strongly which
features are useful without wearing out the utility of others.

# Setting up a Chef workstation

Just use ChefDK for this. Don't even consider anything else. There's no
reason not to use it, and it's an out-of-the-box supported toolchain
from Chef themselves.

While talking to other folks, I've heard some gripes that Chef seems a
bit opinionated in that you need to have `/opt/chefdk/bin` at the front
of your `$PATH`, but I've largely found those invalid.

See, back in the CVS days, I would often jump between various
`$CVSROOT`s, and I found it somewhat cumbersome to keep `export`ing that
variable each time I would switch. Instead, I wrote a script vaguely
like the following and named it `$HOME/bin/with-local-cvs`:

	#! /bin/sh
	exec env CVSROOT=/cvs "$@"

From there, I could do things like `with-local-cvs cvs up`. That's very
easy and very elegant. However, the best part was that I could use
`bash` TAB-completion to expand words at point for those various little
commands.

Similarly, for ChefDK, I use a script called `chefdkify` to set this up,
which is available in the same directory as this wordy thing you're
reading right now. This allows me to use all of my rbenv-installed
Rubies for everything but Chef-related tasks but to use ChefDK for Chef
tasks when I need to. It's a net win for everybody.

The only bad thing is that commands are now `chefdkify knife ...`
instead of simply `knife ...`, but with TAB-completion, that's a
non-issue.

# A strategy for chef-server

I think chef-server is great, but it's likely just best used as a means
for coordinating cookbook updates. I haven't found much utility in
persisting meaningful `node` objects to it, and I haven't found much
of an advantage in doing cross-`node` `search`es. For smaller
infrastructures, it might work, but I would highly advise investing time
in implementing a proper inventory management system or service
management console. You'll thank yourself for it later.

Now, here's the beautiful part. You can inform your `chef-client`'s
`run_list` from these systems and keep that data out of chef-server, and
even better, you can write small Ohai plugins with a minimal amount of
fuss that will interrogate those systems as required to replace this
functionality.

(If you've ever used Microsoft Azure, you'll note that they actually
sort of do this when you provision Linux VMs and opt to install the
Azure agent on them.)

This means, then, at least in conjunction with another couple of things
that I'll talk about in a moment, that your chef-server infrastructure
is now completely and totally stateless. You can put a bullet in it,
stand up new infrastructure, point your clients at the new servers, and
not really worry too much about whether or not you've now horked your
infrastructure management.

That's serious risk mitigation. That's business continuity. That's
robustness.

Now, that doesn't come without some caveats though. For that to work
well, you do need to monkey-patch `chef-client` such that it doesn't
send up a ton of `node` object data whenever `node.save` is called.
Thankfully, the `whitelist-node-attrs` cookbook from the Chef
supermarket is already there to do this for you.

You also need to make sure your version control infrastructure is solid,
robust, and fault tolerant, at least from a business continuity
perspective. Your VCS already has these properties though, right?

# Opinions on version control

Frankly, I'm a big fan of using Subversion as the source of truth. It's
stable, supported by a lot of environments and tools, well-known by
software developers and operators alike, and reasonably flexible in what
you can do with it.

(Also, as an aside, I use "Subversion" to refer to the conceptual
version control product as a whole, `svn` to refer to the Subversion
client, and "the source of truth" to refer to the Subversion server
somewhat nebulously. Let's clarify that before anyone gets confused.

Let's also clarify that, if you're only concerned about implementing a
VCS for operations, use whatever you like. Git suffices perfectly fine
for that. My assumption is that you want to lump everything in together,
in one place, for both development and operations, just to drive the
whole agile operations point home. Subversion allows everyone to invoke
a divide-and-conquer strategy to get work done.)

One of my favorite features of Subversion is being able to check out a
subset of a repository as a local working copy. That's tremendously
powerful, and if you organize your repository well enough, that paves
the way for tremendous inroads when it comes to discoverability and
slashes down your ramp-up time for new hackers to dive in and make
meaningful contributions.

That said, I think `svn`'s strategy for working copies is abysmally bad.
I do much prefer to wrap Subversion in `git-svn` and swap patches with
my colleagues in the typical Git way.

_So, hold up,_ you're probably thinking to yourself. _These seem to be
somewhat diametrically opposed things. You like Subversion for some
things, but then you rail on `svn` for being terrible. There's gotta be
a catch._

There is. The catch is that Subversion runs with just a single branch,
and changes headed toward Subversion must, without exception, go through
a code review tool. You can work in the shadows however which way you
like, but when you come into the light, the workflow is extremely
prescribed, and your changes will be illuminated quite brightly for
everyone to see.

Ideally, you'd leave commit access open to everyone and adopt a model of
"fuck it, I'll just commit it without the prescribed CL and ask for
forgiveness later." This is implemented at one shop as a post-commit
audit hook and is used for public shaming, which I find quite agreeable.

From a psychological perspective, the positive praise garnered from good
CLs far, far outpaces the negative attention garnered from cowboy
commits to HEAD, which means, assuming that submitting CLs is not
encumbered in a whole lot of ceremony, folks will gravitate toward
submitting CLs instead of resorting to the tactics of the wild west.

Nevertheless, the point is that everyone is aware of what goes into the
source of truth. Everyone has full access to every CL for every
"repository" in the organization, and it all shares the same parent
root.

Another overarching theme here is that HEAD _is_ production. Full stop.
_Whoa, wait,_ you think to yourself, _What about testing changes that
need to land in production?_ I implore you to have patience; we'll get
there soon enough.

Also, don't worry about an overload of change information. That's what
grep is for. Seriously.

# ITSM change control tools are now gone (kinda)

I say that they're kinda gone mainly because there's still some degree
of risk management required in the non-software aspects of
infrastructure operations, namely anything that happens in the data
center. That's likely still going to require the involvement of a change
advisory board or some other organ to review what's going on and when.

However, not all is lost; you can carve a part out of your big, giant
Subversion repository there to hold all of the myriad documentation for
each scheduled procedure that you intend to run, submit those as CLs to
land in HEAD, and get approvals amongst your immediate teammates as
needed on them before you commit to running them or handing everything
up to the aforementioned CAB.

That's just cool as hell. Forgive me for being excited about it.

Now, the other parts past that, depending on who you are and what your
background is, may or may not be obvious. The short story really is that
software-oriented infrastructure changes aren't much different from the
CL workflow I just described.

The only real difference is that development teams and operations teams
work together, in the same space, as their own giant CAB. This time,
however, the CAB is _implicit_. It isn't a formalized institution of
individuals wearing purple robes to whom you must plead your case that a
change must be made; instead, the folks who referee your changes are
your peers. Since they're in the trenches with you, they're less likely
to miss important details or, frankly, less likely to shrug you off when
you need help testing something before it lands in HEAD.

# OK, but what about testing and integration?

This one's easy: Use chef-zero. Stand up a whole new ephemeral Chef
server with the contents of your working copy as you want to test it.
Then, find an unsuspecting node somewhere--or provision a new one--and
instruct it to talk to your chef-zero instance.

Recall my remarks about `git-svn` earlier. If you're working in the
shadows, it makes perfectly good sense to create a topic branch for all
of this work and to wall yourself off for a little while. That's the
whole point of the bringover-modify-merge model of source management.

The magic happens, though, when you take your topic branch and upload
its contents to that chef-zero instance. You now have a development Chef
server, just for you and your changes, that will now allow you to have
an edit-compile-run cycle. In addition, since it's running in your
production infrastructure, it is afforded access to production
facilities.

How cool is that?

# How does actual cookbook development work?

TODO: Go over lack of versions in `metadata.rb`. 

TODO: Illustrate how working the shadows could integrate well with
working fully illuminated, to use allegory developed earlier.
