clear
lato=11;
telecamere_su_lato=((lato-2)/3);
telecamere=telecamere_su_lato^2;
A=zeros(lato,lato);
raggio=3.5;  
C=zeros(telecamere*2,lato*lato);  %matrice di copertura

for i =1:telecamere_su_lato
    for j =1:telecamere_su_lato
     A(i*3,j*3)=2;%assegno telecamere alla mappa
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
                                C((i+j/3-3),k*lato+w-lato)=1;  %inserisco l'elemento nella matrice di copertura
                            end
                            if(angolo==2 && k>=i)                         % guardo sotto
                                if(A(k,w)~=2)
                                A(k,w)=1;                                 %segno sulla mappa che ho visto il punto 
                                end
                            C((i+j/3-3)+telecamere,k*lato+w-lato)=1;  %inserisco l'elemento nella matrice di copertura
                            end

                                
                        end
                     end
                  end
              end
         end
    end
end




% PUNTI IMPORTANTI
numero_di_uni = 5;

s = zeros(1,lato*lato);

while(numero_di_uni~=sum(s))
    s(randi([1, lato*lato], 1, 1)) = 1;
end
writematrix(s, "TEST2sj.txt")

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
ALPHA=0.21; %2 in piu accendo
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
    Secondo_termine_J=Secondo_termine_J+(1-s(i))*X(i)*ALPHA;
end
J_UP=sum(Y)-Secondo_termine_J

writematrix(C, "TEST2.txt")







