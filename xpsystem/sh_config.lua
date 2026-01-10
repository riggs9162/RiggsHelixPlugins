ix.config.Add("xpTime", 600, "The time interval (in seconds) for players to gain XP.", nil, {
    data = {min = 60, max = 3600},
    category = "XP System"
})

ix.config.Add("xpGainAmountUser", 5, "The amount of XP regular users gain every interval.", nil, {
    data = {min = 1, max = 100},
    category = "XP System"
})

ix.config.Add("xpGainAmountDonator", 10, "The amount of XP donators gain every interval.", nil, {
    data = {min = 1, max = 200},
    category = "XP System"
})
