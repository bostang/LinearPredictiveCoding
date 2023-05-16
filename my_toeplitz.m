function A = my_toeplitz(r)
% Membuat matriks toeplitz dengan menggunakan konstruk dasar program
% Inputs:
%   - r: baris pertama matriks Toeplitz
% Outputs:
%   - A: matriks Toeplitz

% Menentukan ukuran matriks Toeplitz
n = length(r);

% Membuat matriks Toeplitz menggunakan for loop
A = zeros(n,n);
for i = 1:n
    for j = 1:n
        if j <= i
            A(i,j) = r(i-j+1);
        else
            A(i,j) = r(j-i+1);
        end
    end
end

end
