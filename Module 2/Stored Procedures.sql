-- Finding where code is used
Use CM_PS1
EXEC sp_depends fnValidateIPAddress

-- Check Database SIZE
Use CM_PS1
exec sp_spaceused