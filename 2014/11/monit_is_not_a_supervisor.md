# monit is not a supervisor

Let's just cut this short: monit is not a process supervisor. Stop
treating it like one. Redact all of the `check process` stanzas in your
configuration, and further strike it from your memory.

Dan Bernstein's daemontools supervision suite, along with the various
descendents of it, are far, far better suited for this task, and they
absolve any systems administrator from having to worry about hacks
involving PID files.

And, yes, PID files are a hack. Stop perpetuating hacks.

Worse, we've been perpetuating them a good 10-15 years longer than we've
needed to, mostly because of poor marketing on DJB's part, or the
behavior of most systems administrators to eschew novel ways of doing
things because they're unfamiliar and strange.

(Furthermore, if you, my dear reader, are running illumos, you already
have SMF, and you likely know about it already, so this article probably
isn't relevant to you. Read on, though, if you're interested.)

# What is monit good for?

Any astute reader would likely be asking themselves, "Well, if monit
isn't a process supervisor, what is it good for?" Consider systems that
are self-healing in the sense that they have some simple automation to
solve common problems.

A good example is JIRA, which does have a bit of a tendency to run into
the weeds with fatal OOMEs that don't actually kill the JVM but will
effectively halt all threads.

That sucks, and logging in every time it happens to give JIRA a kick
also sucks. How can we make it better?

Well, for starters, run JIRA under daemontools, and use multilog to
capture the application container's output on standard out to a
multilog-style log directory.

Once you have that done, put the following into your monit config,
assuming that your Tomcat container's logs live at
`/service/j2ee_instance.jira.com-jira/log/main/current`:

	check file j2ee_instance_jira_com_jira_log_main_current
		with path /service/j2ee_instance.jira.com-jira/log/main/current
		if match "java.lang.OutOfMemoryError"
		then exec "sh -c '/command/svc -t /service/j2ee_instance.jira.com-jira && sleep 75 && pgrep instance.jira.com-jira && /command/svc -k /service/j2ee_instance.jira.com-jira'"

Now, since you've put this stanza into your configuration, monit will
check the JIRA container's log for lines that match our OOMEs and give
the application a gentle bounce, optionally killing it if it doesn't die
within 75 seconds.
