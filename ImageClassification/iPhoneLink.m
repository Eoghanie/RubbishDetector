% Tidy up
clc
close all
clear all

% Connect my phone, assign a letter to it
m = mobiledev("iPhone - Gustav’s iPhone");
cam = camera(m,'back'); % Use back camera on my phone
net = googlenet; % Specifies which network to use
label = camnet(cam,net); % Label what is pictured using specified network

