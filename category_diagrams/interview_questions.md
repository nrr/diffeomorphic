# Interview questions for systems engineers

I really dislike the usual trend to harp on technologies when it comes
to hiring systems engineers. What you end up getting are people who
don't particularly know anything except that one particular technology
well. Or, worse, you end up getting 1990's-era systems administrators
who aren't particularly well-versed in much of anything but the command
line.

I mean, it's great that you're using something like Chef and that you
want to hire folks who know Chef, but I wouldn't outright advertise that
you're looking specifically for that skill. I personally picked up Chef
over the course of a couple of months on the job; previously, I'd
written daemontools run scripts and cfengine promises to perform my
systems automation tasks. I also had minimal Puppet experience writing
facter plugins. Anyone worth their salt will generally just pick it up
unless it's particularly obtuse.

The general aim with systems engineers, at least in my experience, is
not to hire specialists. Rather, your best systems engineers are going
to be the ones who can reason about a system that they have _never_ seen
before and be able to tear it apart to figure out how it works.

A better gauge for measuring this particular quality happens to be
asking some pointed questions to see how well-read the candidate is. A
better gauge still is to ask to see some work from this individual. An
even better gauge still is to take this individual from one of your open
source projects, where they have been submitting patches to fix bugs or
implement additional functionality.

In essence, you're hiring reverse engineers for production systems.

Now, that all said, failing to answer these questions will not make you
immediately fail an interview with me. In fact, if you're a motorcycle
mechanic for a racing team, for example, and you've demonstrated to me
that you understand systems thinking with all sorts of motorcycle
maintenance and tuning allegory, and you use Linux as a hobbyist,
there's a great chance that I may take the risk on you. That, and the
perspective diversity gains would be truly wonderful.

- - -

When reviewing the source code for a program, you notice a constant
being defined:

	const char *SOME_THING = {0xad, 0xea, 0xdc, 0xa7, 0};

You later see it being persisted out to disk or sent across the network.
What may be the significance of this constant?

- - -

Which signals (assume Linux 2.6+) are not maskable? 

- - -

Describe some good patterns for handling signals in a multi-threaded
program.

Bonus: Consider some signal handling anti-patterns and explore when and
why they break down in this case.

- - -

When computing the load average, which two process states (assume Linux
2.6+) does the kernel count toward it?

Bonus: Explain the significance of the load average.

Bonus bonus: Explore why relying on a machine's load average to gauge
its health is often not a wise idea.

- - -

What steps in the bootup sequence does `kexec()` skip?

- - -

Describe the general procedure for building and installing the Linux
kernel.

Bonus: Explain how to upgrade a running kernel without fully rebooting.

Bonus bonus: Why is the kernel image itself compressed?

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

	int *a = (int)calloc(sizeof int);
	int b = *a;

Bonus bonus: How can you fix it so that it isn't bad anymore?

Bonus bonus bonus: Can you come up with an analogous example in Java?
Without using JNI?

- - -

Can you write a very simple process supervisor?

If not, can you reason about how to write one? Assume that your
processes always run foregrounded and that they don't call, e.g.,
`setsid()`.

Bonus: How can you bubble up standard output from the supervised
process? Why is this useful?

- - -

Explain how syslog works and some of the caveats of using it on a system
that generates a lot (say, 200 MBytes/s) of logging data.

Bonus: Can you come up with reasons why someone may be entirely averse
to using syslog in any capacity?

- - -

Explain why it might be bad to ship your logs indiscriminately across
the network.

Bonus: What are some alternatives?

Bonus bonus: How would log analysis work?

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

What is your first instinct? Assume Linux on x86_64, a recent glibc, a
program written in C or C++, and that you can move the core dump
somewhere identical with symbol data, just to make it easy. Also, feel
free to assume that it is single-threaded to limit the scope a bit.

First: If it's continuing to dump core in an inconvenient place, how do
you go about telling the OS to dump core somewhere else?

Bonus: What if you didn't have the source code for the task worker?

Bonus bonus: What if it were multi-threaded?

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

Describe how you would build your ideal monitoring system. Be sure to
list your assumptions about what is being monitored.

How will it hold up to clusters of 100 nodes? 1000? 10,000?

Will it adequately handle multiple clusters of the above sizes as if you
were running in more than one datacenter or geographic region? If not,
why? Can you work around that?

Will it adequately handle a very heterogeneous (say, one workload
represents maybe a 1% sample of the cluster's running tasks) collection
of workloads? If not, why? Can you work around that?

- - -

Describe your ideal configuration management system. Be sure to list
your assumptions about what is being configured.

How will it hold up to clusters of 100 nodes? 1000? 10,000?

Will it adequately handle multiple clusters of the above sizes as if you
were running in more than one datacenter or geographic region? If not,
why? Can you work around that?

Will it adequately handle a very heterogeneous (say, one workload
represents maybe a 1% sample of the cluster's running tasks) collection
of workloads? If not, why? Can you work around that?

- - -

Why might cron be a bad idea for a large distributed system? What is a
better alternative?

Bonus: How can you make cron work in this instance?

- - -

Explain how memory allocation works on Linux. Assume ext4fs. Assume
x86_64.

- - -

What happens when you truncate an `mmap()`ed file on ext4fs? On ZFS?

- - -

If you had to write your own /bin/init, what language(s) would you use
and why?

- - -

How should you tool your monitoring system to avoid having downtime?

- - -

Explain some possible candidates for consensus algorithms. What are
their strengths? What are their weaknesses? Make sure to list your
assumptions for each one.

Bonus: Provide a worst case time analysis for your algorithms.

Bonus bonus: Provide a worst case space analysis for your algorithms.

- - -

What are some serious drawbacks about using Paxos in production systems?

- - -

Explore a case study of a production incident involving a distributed
system. List the assumptions of various parts of the system and note how
those assumptions were violated.

What could have been done differently to mitigate disaster? If disaster
did not strike, what ultimately saved the system from disaster?

- - -

How would you implement service discovery for a cluster of 100 nodes?
1000? 10,000?

- - -

You've lost 200 kB of a 2 GB file due to some error somewhere. What do
you do?

- - -

Why is "backup system" a bit of a misnomer?

- - -

Suppose you were designing your ideal backup system. What features would
you implement? What concerns would you address to mitigate disaster?

What architectural features would your backup system have?

What would be your RPO and RTO targets?

- - -

There's a core dump on one of your servers' disks from a program that
was compiled with `-O2` and without `-g`. What do you do? (Crying may be
your first instinct, which is why I didn't ask that here.)

What if it really were compiled with `-g`? What changes?

Suppose that you don't have the binary anymore. What's your first
instinct? (See what I did there?)

- - -

There's a lot of furor about Docker and containerization in the industry
at the moment. Describe in a few words what problems you believe Docker
solves.

Suppose now that you're Google circa 2004-07, and you have a pressing
business need to run several hundred applications from myriad internal
development teams across clusters of myriad nodes. Without considering
the coordination problem, what tools would you use on each node? (You
have Linux, coreutils, glibc, Xen paravirtualization, etc.)

Given your solution above, what would happen if there existed a workload
that is largely block I/O-heavy alongside a workload that is CPU-heavy?
What would happen in the case of CPU-heavy workloads running alongside
other CPU-heavy workloads? I/O-heavy workloads alongside other I/O-heavy
workloads?

Would an application from team A be able to see the files of the
deployment from team B? How would you mitigate that?

Would you be able to guarantee that an application deployment on, say,
Tuesday would be identical to another one performed (with the same
parameters, etc.) the following Thursday? What tools would you use to
guarantee such a thing?
