USE MTRS;
GO

ALTER TABLE Users ADD EncryptedEmail VARBINARY(MAX);

-- Create Master Key only if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name LIKE '%DatabaseMasterKey%')
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongP@ssword123!';
GO

-- Create Certificate if not exists
IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'UserEncryptionCert')
    CREATE CERTIFICATE UserEncryptionCert
    WITH SUBJECT = 'Certificate for User Data Encryption';
GO

-- Create Symmetric Key if not exists
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'UserSymmetricKey')
    CREATE SYMMETRIC KEY UserSymmetricKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE UserEncryptionCert;
GO

-- Encrypt Email field
OPEN SYMMETRIC KEY UserSymmetricKey
DECRYPTION BY CERTIFICATE UserEncryptionCert;
GO

UPDATE Users
SET EncryptedEmail = EncryptByKey(Key_GUID('UserSymmetricKey'), Email);
GO

-- View decrypted data
OPEN SYMMETRIC KEY UserSymmetricKey
DECRYPTION BY CERTIFICATE UserEncryptionCert;
GO

SELECT 
    User_ID,
    Email AS OriginalEmail,
    CONVERT(VARCHAR(255), DecryptByKey(EncryptedEmail)) AS DecryptedEmail
FROM Users;
GO

CLOSE SYMMETRIC KEY UserSymmetricKey;
GO