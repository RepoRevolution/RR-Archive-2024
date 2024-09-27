Config = {}
Config.Debug = false

Config.Database = {
    -- Table name where the all characters are stored.
    characters_table = 'users',
    -- Tables or tables columns that should be ignored by the system to search for money. If `true` is set, then all columns in the table will be ignored. You don't need to add tables where money is not stored, but it will speed up the system.
    ignored_tables = {
        ['users'] = { 'inventory', 'skin', 'loadout', 'status', 'position', 'metadata' },
        ['job_grades'] = true,
        ['ox_doorlock'] = true,
        ['multicharacter_mugshots'] = true,
    },
    -- In some tables, money is stored as a column, fe. `money` column, so system searches for `column_keywords` in the database columns.
    column_keywords = {
        'money'
    },
    -- In some tables, money is stored as a child objects, fe. `inventory` column, so system searches for `column_keywords` in the database columns, and later `object_keywords` in columns.
    object_keywords = {
        'money', 'bank'
    },
    -- In some tables, money is stored as a child objects, fe. `inventory` column, so system searches for `object_keywords` in the column, and later `object_fields_keywords` in the object fields to know how much money is stored in the object.
    object_fields_keywords = {
        'count', 'amount'
    }
}

Config.Money = {
    -- The amount of money, that character gets on the start.
    per_character_start = 5000,
    -- The amount of money difference in fields, that will be marked as a warning.
    difference_warning = 10000,
    -- Update interval in minutes. The system will check the money difference every `update_interval` seconds.
    update_interval = 10
}