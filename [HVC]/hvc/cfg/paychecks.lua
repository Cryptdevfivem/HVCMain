local cfg = {}

cfg.paychecks = {
    -- Police
    {
        name = "Commissioner",
        paycheck = 80000,
        permissions = {"commissioner.paycheck"}
    },
    {
        name = "Deputy Commissioner",
        paycheck = 75000,
        permissions = {"deputycommissioner.paycheck"}
    },
    {
        name = "Assistant Commissioner",
        paycheck = 70000,
        permissions = {"assistantcommissioner.paycheck"}
    },
    {
        name = "Deputy Assistant Commissioner",
        paycheck = 65000,
        permissions = {"assistantdeputycommissioner.paycheck"}
    },
    {
        name = "Commander",
        paycheck = 60000,
        permissions = {"commander.paycheck"}
    },
    {
        name = "Chief Superintendenet",
        paycheck = 55000,
        permissions = {"chiefsuperintendent.paycheck"}
    },
    {
        name = "Superintendenet",
        paycheck = 50000,
        permissions = {"superintendent.paycheck"}
    },
    {
        name = "Cheif Inspector",
        paycheck = 45000,
        permissions = {"chiefinspector.paycheck"}
    },
    {
        name = "Inspector",
        paycheck = 40000,
        permissions = {"inspector.paycheck"}
    },
    {
        name = "Sergeant",
        paycheck = 35000,
        permissions = {"sergeant.paycheck"}
    },
    {
        name = "Special Police Constable",
        paycheck = 30000,
        permissions = {"spc.paycheck"}
    },
    {
        name = "Senior Police Constable",
        paycheck = 25000,
        permissions = {"seniorpolice.paycheck"}
    },
    {
        name = "Police Constable",
        paycheck = 20000,
        permissions = {"policeconstable.paycheck"}
    },
    -- EMS
    {
        name = "EMS Department",
        paycheck = 5000,
        permissions = {"emsChief.paycheck"}
    },
    {
        name = "EMS Department",
        paycheck = 3000,
        permissions = {"emsLieutenant.paycheck"}
    },
    {
        name = "EMS Department",
        paycheck = 2000,
        permissions = {"emsMedic.paycheck"}
    },
    {
        name = "EMS Department",
        paycheck = 2500,
        permissions = {"emsSearchRescue.paycheck"}
    },
    --JOBS
    {
        name = "Mafia",
        paycheck = 10000,
        permissions = {"mafia.paycheck"}
    },
    {
        name = "Repair Company",
        paycheck = 2000,
        permissions = {"repair.paycheck"}
    },
    {
        name = "UBER",
        paycheck = 2000,
        permissions = {"uber.paycheck"}
    },
    {
        name = "Saul Goodman Lawyers",
        paycheck = 2000,
        permissions = {"Lawyer.paycheck"}
    },
    {
        name = "DHL Delivery",
        paycheck = 2000,
        permissions = {"delivery.paycheck"}
    },
    {
        name = "Benefits",
        paycheck = 2000,
        permissions = {"citizen.paycheck"}
    },
    {
        name = "Bank Driver",
        paycheck = 2000,
        permissions = {"bankdriver.paycheck"}
    },
    {
        name = "EasyJet Flights",
        paycheck = 2000,
        permissions = {"pilot.paycheck", "air.paycheck"}
    },
    {
        name = "UPS Postal",
        paycheck = 2000,
        permissions = {"ups.paycheck"}
    },
    {
        name = "Trash Collector",
        paycheck = 2000,
        permissions = {"trash.paycheck"}
    },
}

cfg.interval = 1800000
return cfg

