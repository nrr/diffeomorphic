# Good Chef practices

In case you're wondering why I chose the word "good" instead of "best,"
just consider that "best" implies that your opinions are the only ones
worth listening to, and that every other opinion is somehow some notion
of "wrong." I disagree with that mentality.

In fact, read the title of this document as "good Chef ideas." The point
is to illustrate a workflow, strategy, and code style that tends to work
for large, heterogeneous, disparate environments. The hope is that the
content contained herein is useful for all environments; however, I will
cheerfully acknowledge that not one size fits all. That right there is,
after all, a core tenet of the Fundamental Systems Truths.

There will be a part of this document that addresses part of the wetware
concerns, namely how to adopt a change-embracing instead of a
change-averse culture. I intend to bust a number of the myths that
operations cannot work with some degree of agility in larger
environments, at least not when it comes to making it work well. The
only real impediment is having executives suspend belief for a moment
while their good engineers do what they're good at and help lead
everyone along to a path of prosperity.

Nevertheless, I particularly like the flexibility that Chef provides,
and it is quite a nice tool for implementing systems automation. The
only failing is that it is a vast and expansive framework within which
to work, very much like C++. You needn't use every feature; instead, you
need to consider very strongly which features are useful without wearing
out the utility of others.

# Setting up a Chef workstation

Use ChefDK for this. Seriously. There's no reason not to, and it's an
out-of-the-box supported toolchain from Chef themselves.

In talking to other folks, I've heard some gripes that Chef seems a bit
opinionated in that you need to have `/opt/chefdk/bin` at the front of
your `$PATH`, but I've largely found those invalid.

See, back in the CVS days, I would often jump between various
`$CVSROOT`s, and I found it somewhat cumbersome to keep having to keep
`export`ing that variable each time I would switch. Instead, I wrote a
script vaguely like the following and named it `$HOME/bin/with-local-cvs`:

	#! /bin/sh
	exec env CVSROOT=/cvs "$@"

From there, I could do things like `with-local-cvs cvs up`. Very easy,
very elegant, and the best part was that I could use `bash`
TAB-completion to expand words at point for those various little
commands.

Similarly, for ChefDK, I use a script called `chefdkify` to set this up.
This allows me to use all of my rbenv-installed Rubies for everything
but ChefDK but to use ChefDK for Chef tasks when I need to. It's a net
win for everybody.

The only bad thing is that commands are now `chefdkify knife ...`
instead of simply `knife ...`, but with TAB-completion, that's a
non-issue.

# A strategy for chef-server

Chef-server is great, but it's likely just best used as a means for
coordinating cookbook updates. I haven't found much utility in
persisting meaningful `node` objects to it, and I haven't found much
of an advantage in doing cross-`node` `search`es. For smaller
infrastructures, it might work, but I would highly advise investing time
in implementing a proper inventory management system or service
management console.

Here's the beautiful part. You can inform your `chef-client`'s
`run_list` from these systems and keep that data out of chef-server, and
even better, you can write small Ohai plugins with a minimal amount of
fuss that will interrogate those systems as required to replace this
functionality.

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

# A strategy on version control

Frankly, I'm a big fan of using Subversion as the source of truth. It's
stable, supported by a lot of environments and tools, well-known by
software developers and operators alike, and reasonably flexible in what
you can do with it.

One of my favorite features of Subversion is being able to check out a
subset of a repository as a local working copy. That's tremendously
powerful, and if you organize your repository well enough, that paves
the way for tremendous inroads when it comes to discoverability and
slashes down your ramp-up time for new hackers to dive in and make
meaningful contributions.

That said, I think Subversion's strategy for working copies is abysmally
bad. I do much prefer to wrap it in `git-svn` and swap patches with my
colleagues in the typical Git way.

_So, hold up,_ you're probably thinking to yourself. _These seem
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

Nevertheless, the point is that everyone is aware of what goes into the
source of truth. Everyone has access to the CL for every "repository" in
the organization, and it all shares the same parent root.

Also, don't worry about an overload of change information. That's what
grep is for. Seriously.
