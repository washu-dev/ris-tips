# Secure Projects

## Organizing secure projects for large teams

In instances where teams/labs require secure storage (HIPAA/FERPA) compliance for a particular project, it would be useful to organize the storage directory to accommodate that. 

Most labs on RIS have access to the following directory:
```bash
/storageN/fs1/<PI-name>/Active
```
Typically all users (graduate students, developers, etc.) will have access to the `Active` directory and thus every directory within it.

This is not ideal for use cases where some projects require an Institutional Review Board (IRB) review, or HIPAA / CITI training before accessing the data.  

Hence, the following is the suggested directory structure under `/storageN/fs1/<PI-name>/Active`

```
Active/
    common/
    secure-projectA/
    secure-projectB/
    ...
```

The general idea is to provide access to different directories in the following way:
1. `common/` - All users under the PI have access to this directory.
2. `secure-projectA/` - Only users who have undergone the necessary processes (IRB Review, HIPAA/CITI training, etc.) should have access to this directory. 
3. `secure-projectB/` - Only users who have undergone the necessary processes (IRB Review, HIPAA/CITI training, etc.) should have access to this directory. These users may be different from those who can access `secure-projectA/`.

## Add/Change RIS directory structure

1. Navigate to the [RIS ServiceNow Portal](https://washu.atlassian.net/servicedesk/customer/portal/2/group/55) and log in with your @wustl.edu email.

2. Choose **Modify Existing Storage**.

3. Fill in the following information:

- Summary: 

> Request to modify Active directory for secure storage


- Storage Allocation Name

> `/storageN/fs1/<PI-name>/Active`

Replace `storageN` with your storage (typically `storage1`, `storage2` or `storage3`).

Replace `<PI-name>` with the appropriate WUSTL ID / allocation name / particular storage path. 

- Description

> - Kindly move read/write permissions for all users from `Active/` to a new `Active/common` directory.
> - Kindly add users `wustl-id-1`, `wustl-id-2` to a new secure directory `Active/secure-projectA`
> - Kindly add users `wustl-id-3`, `wustl-id-4` to a new secure directory `Active/secure-projectB`

- WUSTL Key List

You can leave this empty because the WUSTL IDs are already provided in the above Description.

If you do want to get the full list of users, do the following:

a) On the login node run `groups` to show the groups you belong to. Find the storage group. It should look something like `storageN-<PI-name>-rw`. 

b) Get the list of users by running `getent group storageN-<PI-name>-rw`.

4. Double check the WUSTL IDs being added to the secure directories. Submit the request.