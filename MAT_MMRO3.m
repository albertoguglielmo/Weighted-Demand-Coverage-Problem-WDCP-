clear 

raggio=3.5;  
% PUNTI IMPORTANTI
k = 50;
ALPHA=0.1; 



lato=80;


numero_di_uni=k;
s = zeros(1,lato*lato);
while(numero_di_uni~=sum(s))
    s(randi([1, lato*lato], 1, 1)) = 1;
end
writematrix(s, "TEST3sj.txt")




telecamere_su_lato=((lato-2)/3);
telecamere=telecamere_su_lato^2;
A=zeros(lato,lato);

C=zeros(telecamere*2,lato*lato);  %matrice di copertura

for i =1:telecamere_su_lato
    for j =1:telecamere_su_lato
     A(i*3,j*3)=2;                  %assegno telecamere alla mappa
    end
end


for i =1:lato 
    for j =1:lato
        for angolo =1:2
           if(A(i,j)==2) %scorro la matrice per cercare le telecamere
              for k =1:lato
                   for w =1:lato  %scorro la matrice per trovare un punto che la mia telecamera copre
                         if((i-k)^2+(j-w)^2<=raggio^2 && (i-k)^2+(j-w)^2~=0)
                            
                       
                            if(angolo==1 && k<=i)                         % guardo sopra
                                if(A(k,w)~=2)
                                A(k,w)=1;                                 %segno sulla mappa che ho visto il punto 
                                end
                                C((i*telecamere_su_lato/3+j/3-telecamere_su_lato),k*lato+w-lato)=1;            %inserisco l'elemento nella matrice di copertura
                            end
                            if(angolo==2 && k>=i)                         % guardo sotto
                                if(A(k,w)~=2)
                                A(k,w)=1;                                 %segno sulla mappa che ho visto il punto 
                                end
                                C((i*telecamere_su_lato/3+j/3-telecamere_su_lato)+telecamere,k*lato+w-lato)=1;  %inserisco l'elemento nella matrice di copertura
                            end
                        end
                     end
                  end
              end
         end
    end
end

numero_di_punti_osservabili_senza_ostacoli=0;   %con possibile ridondanza
for i =1:telecamere_su_lato*telecamere_su_lato*2
       for j =1:lato*lato
           numero_di_punti_osservabili_senza_ostacoli=numero_di_punti_osservabili_senza_ostacoli+C(i,j);
       end 
end

for k=1:telecamere_su_lato*telecamere_su_lato*2
 verifica=0;
 for i=1:lato*lato
     verifica=verifica+C(k,i);
 end
 Mprima(k)=verifica;
 end

%inseriamo randomicamente degli ostacoli che riducono la visibilita di cira il 10% ((lato*lato*2*telecamere_su_lato*telecamere_su_lato)/10)
for j =1:(lato*lato*2*telecamere_su_lato*telecamere_su_lato)/10
       C(randi([1,telecamere_su_lato*telecamere_su_lato*2]),randi([1,lato*lato]))=0;
end


numero_di_punti_con_ostacoli=0; %con possibile ridondanza
for i =1:telecamere_su_lato*telecamere_su_lato*2
       for j =1:lato*lato
           numero_di_punti_con_ostacoli=numero_di_punti_con_ostacoli+C(i,j);
       end 
end

writematrix(C, "TEST3.txt")
for k=1:telecamere_su_lato*telecamere_su_lato*2
 verifica=0;
 for i=1:lato*lato
     verifica=verifica+C(k,i);
 end
 Mdopo(k)=verifica;
 end



numero_di_punti_con_ostacoli
numero_di_punti_osservabili_senza_ostacoli





%%%UPPER BOUND

%OBLIGATORI
Y=zeros(1,telecamere*2);
X=zeros(1,lato*lato);
vettore_dei_gia_presi=zeros(1,lato*lato);
C_nuova=C;
for j=1:lato*lato
    if(s(j)==1)
        boolean=0;
        for i=1:telecamere*2
            if (C(i,j)==1 && boolean==0)
                boolean=1;
                vettore_dei_gia_presi=C(i,:);
                Y(i)=1;
                X=X+C(i,:);
                for jj=1:lato*lato
                      if(vettore_dei_gia_presi(jj)==1)
                        for ii=1:telecamere*2
                            C_nuova(ii,jj)=0;
                         end
                      end
               end
            end
        end
    end
end


%PARAMETRO ALPHA

for i=1:telecamere*2
    if(sum(C_nuova(i,:))>=1/ALPHA)
        boolean=0;
        for j=1:lato*lato
            if (C(i,j)==1 && boolean==0)
                boolean=1;
                vettore_dei_gia_presi=C(i,:);
                 Y(i)=1;
                X=X+C(i,:);
                for jj=1:lato*lato
                      if(vettore_dei_gia_presi(jj)==1)
                        for ii=1:telecamere*2
                            C_nuova(ii,jj)=0;
                         end
                      end
               end
            end
        end
    end
end



for kuk=1:lato*lato
if(X(kuk)>1)
    X(kuk)=1;
end
end
%FUNZIONE OBBIETTIVO UP
Secondo_termine_J=0;
for i=1:lato*lato
    Secondo_termine_J=Secondo_termine_J+(1-s(i))*X(i)*ALPHA
end
J_UB=sum(Y)-Secondo_termine_J
X_UB=sum(X)
Y_UB=sum(Y)
writematrix(C, "TEST2.txt")



