################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"../Project_Settings/Startup_Code/startcf.c" 

C_SRCS += \
../Project_Settings/Startup_Code/startcf.c 

OBJS += \
./Project_Settings/Startup_Code/startcf.obj 

OBJS_QUOTED += \
"./Project_Settings/Startup_Code/startcf.obj" 

C_DEPS += \
./Project_Settings/Startup_Code/startcf.d 

OBJS_OS_FORMAT += \
./Project_Settings/Startup_Code/startcf.obj 


# Each subdirectory must supply rules for building sources it contributes
Project_Settings/Startup_Code/startcf.obj: ../Project_Settings/Startup_Code/startcf.c
	@echo 'Building file: $<'
	@echo 'Invoking: ColdFire Compiler'
	"C:\Program Files (x86)\Freescale\CW MCU v10.0\eclipse\../MCU/ColdFire_Tools/Command_Line_Tools/mwccmcf" @"Project_Settings/Startup_Code/startcf.args" -o "Project_Settings/Startup_Code/startcf.obj" "$<"
	"C:\Program Files (x86)\Freescale\CW MCU v10.0\eclipse\../MCU/ColdFire_Tools/Command_Line_Tools/mwccmcf" @"Project_Settings/Startup_Code/startcf.args" -o "Project_Settings/Startup_Code/startcf.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Project_Settings/Startup_Code/%.d: ../Project_Settings/Startup_Code/%.c
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '


