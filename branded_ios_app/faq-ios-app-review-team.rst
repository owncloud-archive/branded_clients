=======================
FAQ iOS App Review Team
=======================

Information from Apple:
https://developer.apple.com/support/app-review/


The product contains cryptography, and whether it classifies for export exemptions.
-----------------------------------------------------------------------------------

No, the product does not contain cryptography. Although the app is ready
to connect via SSL, this does not imply that the app includes any
cryptography

How does the app utilize Document Picker and File Provider extensions?
----------------------------------------------------------------------

The ownCloud app takes advantage of the Document Provider extensions so
that those apps that act as Document Picker may access to the ownCloud
data, edit it and then changes are automatically uploaded back to the
ownCloud server.

Please revise your app to provide audible content to the user while the app is in the background or remove the “audio” setting from the UIBackgroundModes key.
--------------------------------------------------------------------------------------------------------------------------------------------------------------

Sometimes, usually, the first time the ownCloud app is submitted, it
is rejected because it is included the background mode, Apple
rejected it because in the past some apps used this trick to avoid the
app to be fully closed. Howerver, the ownCloud app used it only when
music is played. This may be checked by Apple reviewers, what we
suggest is to be proactive, instead of waiting for the app to be
rejected because of that, adding an explanation line, something such as:
You may notice that the app is ready to play music not only in
foreground but also in background, for you to test it we have uploaded
to the test account the file XXX

Content Rights - Does your app contain, display, or access third-party content?
-------------------------------------------------------------------------------

If the branded app has the help option enable, the answer is yes. Within
the help, we are having access to an external web Otherwise, no

Does this app use the Advertising Identifier (IDFA)?
----------------------------------------------------

No, no ads at all
