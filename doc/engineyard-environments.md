# EngineYard Environments

We use engineyard for production and uat/preprod environments.

## SSH

You can SSH into a box and muck about, to do so, you will need.

1. Your SSH Public Key attached to your EngineYard account.
1. That SSH Key installed on each environment you wish to connect to.

Optionally you can streamline this process by storing the addresses of certain hosts in your `~/.ssh/config` file.

#### EngineYard
##### Adding your SSH Key

[EngineYard - Adding your SSH Key](https://support.cloud.engineyard.com/hc/en-us/articles/205407248-Add-an-SSH-Key)

> ###### To add an SSH key to Engine Yard Cloud
> 1. Locate and copy the public key on your local machine. The default location of this file is:
       `~/.ssh/id_rsa.pub`
> 2. In your Dashboard, click on the Tools drop-down.
> 3. Click SSH Public Keys.
> 4. Click Add a new SSH public key.
> 5. Enter a name for the key.
> 6. Paste the key (from Step 1) into the Public Key field.
> 7. Click Add Key.
> 
> You receive a confirmation that your SSH public key has been created and added to your Engine Yard account.

##### Install A Public Key To An Environment

[EngineYard - Install A Public Key To An Environment](https://support.cloud.engineyard.com/hc/en-us/articles/205407268-Install-a-Public-Key-to-an-Environment)

> ###### To update an environment with an SSH key
In your Dashboard, click the environment name.
For example, the “production” environment of the “MyApp” application.

> On the Environment page, click Edit Environment.

> Locate the SSH Keys section and select the keys you want to install.

> Click Update Environment to save your changes.

> (Optional) Repeat these steps for each environment you want to install a key on.

> ###### To deploy keys
> After an environment has been updated with one or more new keys, the keys need to be deployed to the environment instances.
> 
> In your Dashboard, click the environment that you want to deploy your key(s) to.
> Click Apply to install the keys.
> After the keys are deployed, you can connect to your instances via SSH.

##### Connect To Your Instance Using SSH

[EngineYard - Connect To Your Instance Using SSH](https://support.cloud.engineyard.com/hc/en-us/articles/205407258-Connect-to-Your-Instance-Using-SSH)

> There are two methods to start an SSH session:

> ##### Manually start a console session
> Open Terminal or your preferred SSH client.

> SSH using your own IP address and username deploy. For example:

> ssh deploy@123.123.123.123 
> SSH using your own amazon hostname and username deploy. For example:
> 
> ssh deploy@ec2-123-123-123-123.compute-1.amazonaws.com 
> ##### Use our automated SSH link
> Go to your dashboard.
> Click an environment you want to connect to.
> Click the SSH link.
> You should receive a prompt to launch an SSH client. Accept this prompt.

## SSH Config

If you are on a unix-like system, you can configure SSH with a config file in your home directory.

```
~/.ssh/config
```

Here you can do things like assign aliases to servers, set default usernames and other very useful stuff.

This is a portion of my ` ~/.ssh/config` file.


```
Host preprod
  Hostname ec2-54-163-229-217.compute-1.amazonaws.com
  User deploy
  ServerAliveInterval 60
```

Note that I do the following.

1. Assign the alias `preprod` the **preproduction** environment.
1. Define the user to `deploy`
1. Set a `ServerAliveInterval`, this keeps the connection live longer.

This means I can simply run `$ ssh preprod` instead of `$ ssh deploy@ec2-54-163-229-217.compute-1.amazonaws.com`

