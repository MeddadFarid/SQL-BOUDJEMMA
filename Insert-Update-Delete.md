## User

### Insert

    INSERT INTO `user` (`Username`, `Password`, `Type`, `Revoked`)
    VALUES ('[Username]', '[Password]', '[Type]', [Revoked]);

### Update

    UPDATE `user`
    SET `Username` = '[NewUsername]', `Password` = '[NewPassword]', `Type` = '[NewType]', `Revoked` = [NewRevoked]
    WHERE `user_id` = [UserID];

### Delete

    DELETE FROM `user` WHERE `user_id` = [UserID];

## Bon

### Insert

    INSERT INTO `bon` (`Date`, `Provider_id`, `Reduction`, `user_id`)
    VALUES ('[Date]', [ProviderID], [Reduction], [UserID]);

### Update

    UPDATE `bon`
    SET `Date` = '[NewDate]', `Provider_id` = [NewProviderID], `Reduction` = [NewReduction], `user_id` = [NewUserID]
    WHERE `bon_id` = [BonID];

### Delete

    DELETE FROM `bon` WHERE `bon_id` = [BonID];

## Bon_Product

### Insert

    INSERT INTO `bon_product` (`bon_id`, `product_id`, `Quantity`, `price`)
    VALUES ([BonID], [ProductID], [Quantity], [Price]);

### Update

    UPDATE `bon_product`
    SET `Quantity` = [NewQuantity], `price` = [NewPrice]
    WHERE `bon_id` = [BonID] AND `product_id` = [ProductID];

### Delete

    DELETE FROM `bon_product` WHERE `bon_id` = [BonID] AND `product_id` = [ProductID];

## History_Bon

### Insert

No direct insertion into this table. History records are automatically created by triggers.

### Update

No update allowed on this table. History records are automatically created by triggers.

### Delete

No deletion allowed on this table. History records are retained for historical purposes.

## Client

### Insert

    INSERT INTO `client` (`name_client`, `phone_client`)
    VALUES ('[ClientName]', '[ClientPhone]');

### Update

    UPDATE `client`
    SET `name_client` = '[NewClientName]', `phone_client` = '[NewClientPhone]'
    WHERE `client_id` = [ClientID];

### Delete

    DELETE FROM `client` WHERE `client_id` = [ClientID];

## Product

### Insert

    INSERT INTO `product` (`product_name`, `price`, `Quantity`, `user_id`)
    VALUES ('[ProductName]', [Price], [Quantity], [UserID]);

### Update

    UPDATE `product`
    SET `product_name` = '[NewProductName]', `price` = [NewPrice], `Quantity` = [NewQuantity], `user_id` = [NewUserID]
    WHERE `product_id` = [ProductID];

### Delete

    DELETE FROM `product` WHERE `product_id` = [ProductID];

## History_Product

### Insert

No direct insertion into this table. History records are automatically created by triggers.

### Update

No update allowed on this table. History records are automatically created by triggers.

### Delete

No deletion allowed on this table. History records are retained for historical purposes.

## Provider

### Insert

    INSERT INTO `provider` (`name_provider`, `phone_provider`)
    VALUES ('[ProviderName]', '[ProviderPhone]');

### Update

    UPDATE `provider`
    SET `name_provider` = '[NewProviderName]', `phone_provider` = '[NewProviderPhone]'
    WHERE `provider_id` = [ProviderID];

### Delete

    DELETE FROM `provider` WHERE `provider_id` = [ProviderID];
