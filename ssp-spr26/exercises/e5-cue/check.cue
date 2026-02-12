min?: *0 | number    
max?: number & >min  
config1?: number & >=min 
config2?: number & >=config1 
config3?: number & >=max
config4?: number & <config2  