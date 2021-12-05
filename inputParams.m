function [density, roadLen, lanes, rounds, randomPos] = inputParams()
%inputParams Eingabe der Parameter.

    syms x y
    while 1
        roadLen = input("Länge der Straße: ");
        if roadLen > 0
            break;
        end
        disp('Ungültige Eingabe!')
    end
    while 1
        lanes = input("Anzahl der Fahrspuren (1 oder 2): ");
        if lanes == 1 || lanes == 2
            break;
        end
        disp('Ungültige Eingabe!')
    end
    while 1
        density = input("Verkehrsdichte (Anzahl der Autos): ");
        if density < 0
            disp('Verkehrsdichte muss größer Null sein!')
        elseif lanes == 1 && density >= roadLen
            disp('Verkehrsdichte muss kleiner als die Straßenlänge sein!')
        elseif lanes == 2 && density >= roadLen*2
            disp('Verkehrsdichte muss kleiner als zwei Straßenlängen sein!')
        else
            break;
        end
    end
    while 1
        rounds = input("Anzahl der Runden: ");
        if rounds > 0
            break;
        end
        disp('Ungültige Eingabe!')
    end
    while 1
        randomPos = input("Zufällige Fahrzeugpositionen (true/false): ");
        if randomPos == true || randomPos == false
            break;
        end
        disp('Ungültige Eingabe!')
    end
end

