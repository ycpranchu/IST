import bitstring, random 

span = 10
iteration = 1000000

def ieee754(flt):
    b = bitstring.BitArray(float=flt, length=32)
    return b

result_a_list = []
result_b_list = []
result_c_list = []

with open("TestFile.txt", "w") as f:
    for i in range(iteration):
        T_x = random.uniform(-span, span)
        T_y = random.uniform(-span, span)
        T_z = random.uniform(-span, span)
        
        P_x = random.uniform(-span, span)
        P_y = random.uniform(-span, span)
        P_z = random.uniform(-span, span)
        
        # result_a = T_x * P_x
        # result_b = T_y * P_y
        # result_c = T_z * P_z 
        # result_a_b_c = result_a + result_b + result_c
        
        # result_a = ieee754(result_a)
        # result_b = ieee754(result_b)
        # result_c = ieee754(result_c)
        # result_a_b_c = ieee754(result_a_b_c)
        
        result_a = T_x * P_x + T_y * P_y + T_z * P_z 
        
        T_x = ieee754(T_x)
        T_y = ieee754(T_y)
        T_z = ieee754(T_z)
        
        P_x = ieee754(P_x)
        P_y = ieee754(P_y)
        P_z = ieee754(P_z)
        
        V_x = random.uniform(-span, span)
        V_y = random.uniform(-span, span)
        V_z = random.uniform(-span, span)
        
        Q_x = random.uniform(-span, span)
        Q_y = random.uniform(-span, span)
        Q_z = random.uniform(-span, span)
        
        result_b = V_x * Q_x + V_y * Q_y + V_z * Q_z
        
        V_x = ieee754(V_x)
        V_y = ieee754(V_y)
        V_z = ieee754(V_z)
        
        Q_x = ieee754(Q_x)
        Q_y = ieee754(Q_y)
        Q_z = ieee754(Q_z)
        
        result_c = result_a + result_b
        
        valid = 1
        if (result_a < 0.0 or result_b < 0.0):
            valid = 0
            result_a = 0
            result_b = 0
            result_c = 0
        else:
            result_a_list.append(ieee754(result_a))
            result_b_list.append(ieee754(result_b))
            result_c_list.append(ieee754(result_c))
    
        result_a = ieee754(result_a)
        result_b = ieee754(result_b)
        result_c = ieee754(result_c)
        
        # f.write(T_x.hex + "_" + T_y.hex + "_" + T_z.hex + "_" + \
        #         P_x.hex + "_" + P_y.hex + "_" + P_z.hex + "_" + \
        #         rayV_x.hex + "_" + rayV_y.hex + "_" + rayV_z.hex + "_" + \
        #         Q_x.hex + "_" + Q_y.hex + "_" + Q_z.hex + "_" + result_a.hex + "_" + result_b.hex + "\n")
        
        f.write(T_x.hex + " " + T_y.hex + " " + T_z.hex + " " + \
                P_x.hex + " " + P_y.hex + " " + P_z.hex + " " + \
                V_x.hex + " " + V_y.hex + " " + V_z.hex + " " + \
                Q_x.hex + " " + Q_y.hex + " " + Q_z.hex + " " + \
                result_a.hex + " " + result_b.hex + " " + result_c.hex + " " + str(valid) + "\n")
        
        print("time: ", i)
        

with open("CheckFile.txt", "w") as f:
    for i in range(len(result_a_list)):
        f.write(result_a_list[i].hex + " " + result_b_list[i].hex + " " + result_c_list[i].hex + "\n")