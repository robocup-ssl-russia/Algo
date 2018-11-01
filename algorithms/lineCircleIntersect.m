function [x, y] = lineCircleIntersect(cX, cY, R, vX, vY, pX, pY)
    pX = pX - cX;
    pY = pY - cY;
    A = vY;
    B = -vX;
    C = vY * pX - vX * pY;
    N = A * A + B * B;
    qX = A * C / N;
    qY = B * C / N;
    
end

