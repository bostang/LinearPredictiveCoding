function [a, e, R] = lpc_autocorr(x, p)
    % Computes the LPC coefficients using the autocorrelation method
    % Inputs:
    %   x: input signal (column vector)
    %   p: order of LPC analysis
    % Outputs:
    %   a: LPC coefficients (column vector)
    %   e: prediction error variance
    
    % Compute autocorrelation vector
    R = xcorr(x, p, 'biased');
    
    
    % Construct autocorrelation matrix
    Rmat = toeplitz(R(p+1:end-1));

    % Construct target vector
    r = R(p:-1:1);
    
    % Solve for LPC coefficients
    a = [1; linsolve(Rmat, r)];
    a(2:end) = -a(2:end);
    e = R(1) - sum(R(2:p+1) .* a(1:p));
end
