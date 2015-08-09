##This code
        ##gets the data and unzips it
        ##reads only the relevant portion into a dataset
                ##(via skip and nrows) and converts question marks to NAs.
        ##reformats date and time variables to make them processable:
                ##creates a uniform datetime variable, formatted as a time,
                ##and formats the date column into date format.
        ##sets up the receiving .png file
        ##creates the histogram for Plot 1
                ##closes .png file

#Initialize files
library(data.table)
ElecPowerConsumption<-data.table()
NameCapture<-data.table()
ElecPowerCatch<-tempfile()
origfileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

##gets the data and unzips it,
download.file(origfileurl,ElecPowerCatch,mode="wb")     #go get the file,
unzip(ElecPowerCatch,"household_power_consumption.txt") #unzip it to extract data,

##reads only the relevant portion into a dataset
NameCapture<-read.table("household_power_consumption.txt",header=TRUE,sep=";",skip=0,nrows=2) #capture column headings
ElecPowerConsumption<-read.table("household_power_consumption.txt",header=TRUE,sep=";",skip=66636,nrows=2880,na.strings="?") #read only the rows for the relevant dates; convert question marks to NA
colnames(ElecPowerConsumption)<-colnames(NameCapture) #attach column headings to small dataset

##reformats date and time variables to make them processable:
datetime<-paste(ElecPowerConsumption$Date,ElecPowerConsumption$Time,sep="/") #creates the datetime variable that we actually plot
datetime<-strptime(datetime,format="%d/%m/%Y/%H:%M:%S",tz="PST8PDT") #converts datetime to a uniform date and time
ElecPowerConsumption<-cbind(datetime,ElecPowerConsumption) #adds the new computed datetime variable to the dataset
ElecPowerConsumption$Date<-as.Date(ElecPowerConsumption$Date,"%d/%m/%Y") #format dates into R-recognizable dates

#sets up the receiving .png file
png(filename = "plot1a.png", #name png file to write to
    width = 480, #set width of plot
    height = 480, #set height of plot
    units = "px") #specify dimension of plot are in pixels)

#creates the histogram for Plot 1

hist(ElecPowerConsumption$Global_active_power, #sets up histogram
     col="red", #color of bars set to red
     main="Global Active Power", #text of main label
     xlab="Global Active Power (kilowatts)", #x axis label
     ylab="Frequency", #y axis label
     outer=FALSE, #position main title within plot space (not page margin)
     family="sans", #use sans serif fonts
     font.main=2, #main title in boldface
    xaxs="r", #calculates intervals for x axis
    yaxs="r", #calculates intervals for y axis
     las=0 #write axis labels parallel to axes
     )

dev.off() #closes .png file

