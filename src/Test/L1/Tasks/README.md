Tasks that are used for Signing tests are pulled down from CIPLat.Externals.

However, we may want to modify these tasks in the future or accomodate different test cases.

In order to do that, we have included the source code here.

# Building

For each task, simply navigate to their root and run:

$ npm install
$ npm build

# Signing

To sign one of the test tasks, you can run:

PS src\Test\L1\Tasks> .\sign-a-task.ps1 ./SignedTaskCertA

This will generate `SignedTaskCertA.zip` in the `L1\Tasks` folder and print out the certificate fingerprint(you'll need to update the tests to use this).
TODO: Store certs in easy to find/update text file and reference that here.

# Uploading

Your updated task will now be signed.

You can upload it to CIPlat.Externals and then run tests locally to make sure they are working.

We recommend creating new versions of the tasks if you need to update them, otherwise you could break existing tests that won't have your code changes.
