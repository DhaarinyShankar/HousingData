/*
Cleaning Data in Nashville housing data using SQL Queries
*/
--Select all the data
select * from Nashvillehousing

Alter table Nashvillehousing 
add SaleDateConverted Date

update Nashvillehousing 
set SaledateConverted= convert(Date,Saledate)

--Populate missing address if parcelId is same

Select ParcelId,PropertyAddress from Nashvillehousing where PropertyAddress is null

Select n.ParcelId,n.PropertyAddress from Nashvillehousing N join Nashvillehousing m on 
m.ParcelId=n.ParcelID where m.ParcelId=n.ParcelID and n.PropertyAddress is null and n.uniqueId<>m.[UniqueID ]

Update m
set PropertyAddress=IsNull(m.PropertyAddress,n.PropertyAddress)
from Nashvillehousing N join Nashvillehousing m on 
m.ParcelId=n.ParcelID where m.ParcelId=n.ParcelID and n.PropertyAddress is null and n.uniqueId<>m.[UniqueID ]

Select propertyaddress from NashvilleHousing

Select 
SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as address,
substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,Len(propertyaddress)) as address
 from Nashvillehousing

 Alter table Nashvillehousing 
add PropertysplitAddress nvarchar(255)

update Nashvillehousing 
set PropertysplitAddress= SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)

Alter table Nashvillehousing 
add Propertysplitcity nvarchar(255)

update Nashvillehousing 
set Propertysplitcity= SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,Len(propertyaddress))

--Split owneraddress

Select 
PARSENAME(Replace(Owneraddress,',','.'),1),
PARSENAME(Replace(Owneraddress,',','.'),2),
PARSENAME(Replace(Owneraddress,',','.'),3) from Nashvillehousing 

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

--Update Y,N as Yes and No for SoldAsVacant
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
set 
SoldAsVacant =Case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end

--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From PortfolioProject.dbo.NashvilleHousing

-- Delete Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
