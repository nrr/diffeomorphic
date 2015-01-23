# Opinions on Version Control Systems

Before we get too far into the weeds here, let me provide just a little
bit of background on my experience with version control systems, what
I've used version control to track, and the environments I've worked in.

I'm one of those crotchety millennials who's used all sorts of really
old awesome stuff like UUCP and SGI's IRIX. You know, things that
_everybody_ yearned one day to have. This also means that I got to use
things like CVS and RCS.

I cut my teeth on things like CVS and RCS, and I spent several years
using Subversion. On the surface, I liked none of them because they all
had some deeply internal flaws that caused a severe impedance mismatch
between the work that I was attempting to do and the work that I would
actually be able to submit for the final product.

Subversion eventually begat SVK for working in a distributed fashion
akin to Git and Monotone, which was kind of neat, but ultimately, Git
wound up winning.

I'm actually quite thankful. Git gets some of the important
psychological barrier fundamentals right while getting some of the
organizational ones wrong, but the organizational ones are very easily
worked around. On top of that, we now had the modify/bring over/merge
workflow available to the masses. It's a pretty good net win.

Nevertheless, the problems of scale for a fast-moving enterprise with a
couple thousand committers are wildly different from the problems of
scale for a fast-moving open source project with thousands of
committers.

It should naturally follow that these scale problems are also quite
different from projects having tens of committers and committers in the
single digits.

# The Philosophy of Version Control in Large Organizations

I make a number of assumptions here, namely:

* You want to allow anyone within the company to make a change to
anything in production at any time, safely, without also breaking
production
* You want to allow a fair amount of flexibility in how modules are
split up between parts of your company's codebase without having to
resort to too much hackery
* You want to be able to hire interns and have them make a
production-impacting change on day one
* You want to spend your time actually doing meaningful work instead of
policing who can commit where

## Anti-pattern: Linking reviews to branches.

Branches are supposed to be places where anyone can sit down and do
something potentially risky and dangerous within some safe confines.

## Anti-pattern: 

In addition, you have some figure of committers across your organization
that's on the order of, say, 10^3.

The first thing that you're going to have to eschew is the notion of
having globally-available branching unless your VCS happens to provide
for it, like Fossil does. Git's branches are clone-local, and you start
getting into some of the more masturbatory aspects of distributed
version control if you venture too deeply there.

Limit the source of truth for your projects to one branch. The Solaris
team at Sun had a 'gate' branch that they used for cutting releases, and
you knew damn well that whatever went in there would wind up being in a
production release of the operating system.

Now, that said, having local branches amongst various projects is
entirely acceptable, but there needs to be some sort of clear
separation of 

# The Implementation of Version Control in Large Organizations
