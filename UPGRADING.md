Upgrading from 0.1.x or earlier

 - create/update/delete methods now take an additional argument to pass, e.g.
    "?publisher_id=5" where appropriate and required.  This goes before the
    "body" hash.


the implementation should probably read advertiser_id/publisher_id from
the object for update/delete but in the cases that both are present, I'm
unsure which one (or both?) should be sent
