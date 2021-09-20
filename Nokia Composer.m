% strat of the code
clc;
clear all;
close all;
song = input ('Enter you song: ' , 's'); % enter the song
song(isspace(song)) = []; % to delete all spaces on the song
eq=find(song=='='); % to  find locations of =
co=find(song==':'); %to  find locations of :
def_d=str2double (song(1+eq(1))); % to get the default duration
def_oct=str2double (song(1+eq(2)));% to get the default octave
beats=str2double (song([(eq(3)+1):(co(2)-1)])); % to get tempo of the song
tone = []; % new empty matrix to filled with the song in the next for loop
for j = co(2)+1 : numel(song)
    tone = [tone song(j)] ;
end
dmat = []; % to store durations
hash = [];% to store if the note has # or no
doct = [];% to store octaves
comma = []; % to store locations of the commas
melody = []; % to store all tones
a = []; % to store thee final song
freq = []; % to store frequences of the notes
% the following paramters to check if the note has . or no
dot =0;  
dotmat =0;

% to get the duration & note for fist one
if (tone(1) < '9')
    if (tone(1) == '1')
         if (tone(2) == '6')
            dmat = [dmat 16];
            melody = [melody tone( 3 )];
         else
              dmat = [dmat 1];
            melody = [melody tone( 2 )];
         end
        elseif (tone(1) =='3')
             dmat = [dmat 32];
            melody = [melody melody tone( 3 )];
        elseif(tone(1) =='6')
             dmat = [dmat 64];
            melody = [melody melody tone( 3 )];
        else 
        dmat = [dmat str2double(tone(1))];
        melody = [melody tone( 2 )];
        end 
else
    dmat = [dmat def_d];
    melody = [melody tone(1)];
end
% to get locations of the commas
for j = 1:numel(tone)  
    if (tone(j) == ',')
        comma = [comma j];
    end 
end
% to check if the first note has # , . or no 
for j = 1 : comma (1)
    
    if (tone(j) == '#')
         hash = [hash 1.059327];
    else
         hash = [hash 1];
    end
     if (tone(j) == '.')
         dotmat=  1;
    end
end
for j = 1:numel(comma)
    % to get the duration & melody
    if (tone( comma (j)+1) < '9')
        if (tone( comma (j)+1) == '1')
            if (tone( comma (j)+2) == '6')
                dmat = [dmat 16];
                melody = [melody tone(comma(j) + 3 )];
            else 
                 dmat = [dmat 1];
                melody = [melody tone(comma(j) + 2 )];
            end
        elseif (tone( comma (j)+1) =='3')
             dmat = [dmat 32];
            melody = [melody tone(comma(j) + 3 )];
        elseif(tone( comma (j)+1) =='6')
             dmat = [dmat 64];
            melody = [melody tone(comma(j) + 3 )];
        else 
        dmat = [dmat str2double(tone(comma (j)+1))];
        melody = [melody tone(comma(j) + 2 )];
        end    
    else 
        melody = [melody tone(comma(j) + 1 )];
        dmat = [dmat def_d];
    end
    %to get octave
     if ((tone(comma (j)-1) < '9' )&& ((tone(comma (j)-1) ~= '#')) && ((tone(comma (j)-1) ~= '.')))
        doct = [doct str2double(tone(comma (j)-1))];
    else 
        doct = [doct def_oct];
     end
     if (j==1)
         continue;
     end
     if (tone(comma(j)-1) == '.' || tone(comma(j)-2) == '.' )
        dot = 1;
        dmat (j) = (2*dmat (j))/3;
    end
    
    % to check if there is #
    if ((tone(comma(j)-1) == '#' || tone(comma(j)-2) == '#' )|| (tone(comma(j)-3) == '#' && dot == 1) )
        hash = [hash 1.059327];
        dot = 0;
    else
        hash = [hash 1];
        dot = 0;
    end
    
    
    
end
lentone = length (tone);
lencomma = length (comma);
%  to check if there is dot in thre last note
for j =  comma(lencomma) : lentone
    if (tone (j) == '.')
        dmat(numel(comma)) = (2*dmat (numel(comma)))/3;
    
    end
end
% to get the octave and if there is hash for the last tone
if (tone (lentone ) < '9')
     doct = [doct str2double(tone(lentone))];
else
     doct = [doct def_oct];
end
if (tone (lentone) == '#' || tone (lentone -1) == '#'|| tone (lentone -2) == '#')
     hash = [hash 1.059327];
else
     hash = [hash 1];
end
q= length (melody); % to get the number of the notes
% to apply the duration change because of the dot
if (dotmat==1)  
dmat(1) = (2*dmat (1))/3;
end
% replace each note with its frequency
for k = 1:q;
    if melody (melody (k) == 'a')
        freq = [freq 55];
    elseif melody (melody (k) == 'b')
        freq = [freq 61.74];
        elseif melody (melody (k) == 'c')
        freq = [freq 32.7];
        elseif melody (melody (k) == 'd')
        freq = [freq 36.7];
        elseif melody (melody (k) == 'e')
        freq = [freq 41.2];
        elseif melody (melody (k) == 'f')
        freq = [freq 42.76];
        elseif melody (melody (k) == 'g')
        freq = [freq 49];
    elseif melody (melody (k) == 'p')
        freq = [freq 0];
    end    
        end    


for k = 1:q; %for loop which will create the melody
note = 0:0.0000625:122.5/(dmat(k)*beats); %note duration (which can be edited for duration & beats)
a = [a sin(2*pi*hash(k)*(2^doct(k))*freq(k)*note)]; %a will create the melody given variables defined above
end
sound(1*a); % plays the melody
%End of code
