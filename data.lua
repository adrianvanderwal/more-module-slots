-- to add an item to the blacklist, add the name of the assembling machine to the table using:
-- mms.blacklist['entity-name'] = true
-- please insert this during your data-updates stage
if not mms then mms = {} end
if not mms.blacklist then mms.blacklist = {} end