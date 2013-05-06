relnetRoute = {}
relnetRoute.__index = relnetRoute

function relnetRoute.create(Destination, Netmask, Gateway, Interface, Metric)
   local this = {}             -- our new object
   setmetatable(this,relnetRoute)  -- make relnetRoute handle lookup
   this.dest = Destination      -- initialize our object
   this.mask = Netmask
   this.gateway = Gateway
   this.interface = Interface
   this.metric = Metric
   return this
end

function relnetRoute:withdraw(amount)
   self.balance = self.balance - amount
end

-- create and use an relnetRoute
-- acc = relnetRoute.create(1000)
-- acc:withdraw(100)