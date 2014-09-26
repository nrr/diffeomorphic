# Interview questions for systems engineers

I really dislike the usual trend to harp on technologies when it comes
to hiring systems engineers. What you end up getting are people who
don't particularly know anything except that one particular technology
well. Or, worse, you end up getting 1990's-era systems administrators
who aren't particularly well-versed in much of anything but the command
line.

The general aim with systems engineers, at least in my experience, is
not to hire specialists. Rather, your best systems engineers are going
to be the ones who can reason about a system that they have _never_ seen
before and be able to tear it apart to figure out how it works.

In essence, you're hiring reverse engineers for production systems.

- - -

Suppose that you're reviewing code for something, and you come across a
couple of lines that read a bit like the following:

	int *a = NULL;
	int b = *a;

What will happen? If it weren't immediately apparent to you (because of,
say, lack of sleep), what steps would your habits dictate you take in
order to debug it?

Bonus: Why is the following (admittedly contrived example) similarly
bad?

	int *a = calloc(sizeof int);
	int b = *a;

- - -

Can you write a very simple process supervisor?

If not, can you reason about how to write one? Assume that your
processes always run foregrounded and that they don't call, e.g.,
`setsid()`.

- - -

Explain how syslog works and some of the caveats of using it on a system
that generates a lot (say, 200 MBytes/s) of logging data.

Bonus: Can you come up with reasons why someone may be entirely averse
to using syslog in any capacity?

- - -

Explain why it might be bad to ship your logs indiscriminately across
the network.

- - -

Suppose you have a configuration management system that includes with it
a proto-inventory management system. You are using this configuration
management system on clusters around the order of 10,000 nodes.

Assume further that each client runs every 15 minutes and that it ships
back about 100 kBytes worth of data to the central server with each run.

What are some performance considerations that you may need to take into
account?

What are some reliability considerations that you may need to take into
account?

- - -

Suppose that you're trying to write some automated tools to build a map
of your network topology, including link speeds and who peers to whom.

You have traceroute. Can you extend that tool to include intermediate
link speeds? If so, how?

- - -

A production service is running a task worker on a compute instance
somewhere (e.g., a virtual machine, a lightweight sandbox, a full
physical machine) but crashing in a seemingly random place. It dumps
core.

What is your first instinct? Assume Linux, a recent glibc, a program
written in C or C++, and that you can move the core dump somewhere
identical with symbol data, just to make it easy.

Bonus: What if you didn't have the source code for the task worker?

- - -

What are some dangers with memory corruption and C++ vtables?

To limit the scope of this a bit, assume that your memory bus itself is
working as intended but that you're getting either, e.g., stuck bits or
weird inversions back from your RAM.

- - -

Explain Brewer's CAP theorem and its significance.

Bonus: Explain why partition tolerance is a strict requirement in any
distributed system.

- - -

Describe how you would build your ideal monitoring system.
